# frozen_string_literal: true

require_relative 'score'
require_relative 'valid_score'
# player information
class Player
  include ValidScore
  attr_reader :name, :global_scores
  attr_accessor :scores

  def initialize(name)
    @name = name
    @scores = []
    @global_scores = (1..10).map { |n| [n, -1] }.to_h
  end

  def add_score(points)
    if @scores.length.zero?
      @scores.push(Score.new(points, 1, 1))
    elsif @scores[-1].frame <= 9
      message = score_before_ten(points)
      return message if message != ''
    else
      message = score_frame_ten(points)
      return message if message != ''
    end
    conditions_global_score
    ''
  end

  private

  def score_frame_ten(points)
    if @scores[-1].frame == 10 && (@scores[-1].roll == 3 || (@scores[-1].roll == 2 && @@valid_score[@scores[-1].points] + @@valid_score[@scores[-2].points] < 10))
      return "current player didn't have more rolls or frames available"
    elsif @scores[-1].roll == 1 && @@valid_score[@scores[-1].points] < 10 && @@valid_score[@scores[-1].points] + @@valid_score[points] > 10
      return 'On the tenth frame, first and second roll cannot surpass 10 points unless the first roll were a strike'
    elsif @scores[-1].roll == 2 && @@valid_score[@scores[-2].points] == 10 && @@valid_score[@scores[-1].points] < 10 && @@valid_score[@scores[-1].points] + @@valid_score[points] > 10
      return 'On the tenth frame, second and third roll cannot surpass 10 points when the first roll was a strike but the second was not a strike'
    end

    @scores.push(Score.new(points, 10, @scores[-1].roll + 1))
    ''
  end

  def score_before_ten(points)
    if @scores[-1].roll == 1 && @@valid_score[@scores[-1].points] < 10
      if @@valid_score[@scores[-1].points] + @@valid_score[points] > 10
        return 'Before frame 10, two rolls in the same frame cannot surpass the 10 points'
      end

      @scores.push(Score.new(points, @scores[-1].frame, 2))
    else
      @scores.push(Score.new(points, @scores[-1].frame + 1, 1))
    end
    ''
  end

  def conditions_global_score
    if @scores[-1].frame == 10 &&
       (@scores[-1].roll == 3 ||
        (@scores[-1].roll == 2 && @@valid_score[@scores[-1].points] + @@valid_score[@scores[-2].points] < 10))
      global_game_score
    end
  end

  def global_game_score
    (0...@scores.length).each do |i|
      current_score = @scores[i].frame == 1 ? 0 : @global_scores[@scores[i].frame - 1]
      if @scores[i].frame < 10
        accumulate(i, current_score)
      elsif @scores[i].frame == 10 && @scores[i].roll == 1
        accumulate_frame_ten(i, current_score)
      end
    end
  end

  def accumulate(index, current_score)
    if @scores[index].frame < @scores[index + 1].frame
      @global_scores[@scores[index].frame] =
      @@valid_score[@scores[index].points] +
        current_score + if @scores[index].roll == 1
          @@valid_score[@scores[index + 1].points] + @@valid_score[@scores[index + 2].points]
                        elsif @scores[index].roll == 2 && (@@valid_score[@scores[index - 1].points] + @@valid_score[@scores[index].points] == 10)
                          @@valid_score[@scores[index - 1].points] + @@valid_score[@scores[index + 1].points]
                        else
                          @@valid_score[@scores[index - 1].points]
                        end
    end
  end

  def accumulate_frame_ten(index, current_score)
    @global_scores[@scores[index].frame] =
    @@valid_score[@scores[index].points] +
    @@valid_score[@scores[index + 1].points] +
      (@scores[index + 2].nil? ? 0 : @@valid_score[@scores[index + 2].points]) +
      current_score
  end
end
