# frozen_string_literal: true

require_relative 'score'
# player information
class Player
  attr_reader :name, :global_scores
  attr_accessor :scores

  def initialize(name)
    @name = name
    @scores = []
    @global_scores = (1..10).map { |n| [n, 0] }.to_h
  end

  def add_score(points)
    if @scores.length.zero?
      @scores.push(Score.new(points, 1, 1))
    elsif @scores[-1].frame <= 9 || (@scores[-1].frame == 9 && (@scores[-1].points == 10 || @score[-1].attempt == 2))
      score_before_ten(points)
    elsif @scores[-1].frame == 10 && (@scores[-1].attempt == 3 || (@scores[-1].attempt == 2 && @scores[-1].points + @scores[-2].points < 10))
      return "current player didn't have more attempts or frames available"
    else
      @scores.push(Score.new(points, 10, @scores[-1].frame == 9 ? 1 : @scores[-1].attempt + 1))
    end
    getter_global_score
    ''
  end

  private

  def score_before_ten(points)
    if @scores[-1].attempt == 1 && @scores[-1].points < 10
      return 'two attempts in the same frame cannot surpass the 10 points' if @scores[-1].points + points > 10

      @scores.push(Score.new(points, @scores[-1].frame, 2))
    else
      @scores.push(Score.new(points, @scores[-1].frame + 1, 1))
    end
  end

  def getter_global_score
    if @scores[-1].frame == 10 &&
       (@scores[-1].attempt == 3 || @scores[-1].points + @scores[-2].points < 10)
      global_game_score
    end
  end

  def global_game_score
    (0...@scores.length).each do |i|
      current_score = @scores[i].frame == 1 ? 0 : @global_scores[@scores[i].frame - 1]
      if @scores[i].frame < 10
        accumulate(i, current_score)
      elsif @scores[i].frame == 10 && @scores[i].attempt == 1
        accumulate_frame_ten(i, current_score)
      end
    end
  end

  def accumulate(index, current_score)
    if @scores[index].frame < @scores[index + 1].frame
      @global_scores[@scores[index].frame] =
        @scores[index].points +
        current_score + if @scores[index].attempt == 1
                          @scores[index + 1].points + @scores[index + 2].points
                        elsif @scores[index].attempt == 2 && (@scores[index - 1].points + @scores[index].points == 10)
                          @scores[index - 1].points + @scores[index + 1].points
                        else
                          @scores[index - 1].points
                        end
    end
  end

  def accumulate_frame_ten(index, current_score)
    @global_scores[@scores[index].frame] =
      @scores[index].points +
      @scores[index + 1].points +
      (@scores[index + 2].nil? ? 0 : @scores[index + 2].points) +
      current_score
  end
end
