# frozen_string_literal: true

require_relative 'score'

class Player
  attr_reader :name, :global_scores
  attr_accessor :total_score, :scores

  def initialize(name)
    @name = name
    @total_score = 0
    @scores = []
    @global_scores = (1..10).map{|n| [n, 0]}.to_h
  end

  def add_score(points)
    if @scores.length==0
        @scores.push(Score.new(points, 1, 1))
    elsif @scores[-1].frame<=9 || (@scores[-1].frame==9 && (@scores[-1].points==10 || @score[-1].attempt==2)) 
        if(@scores[-1].attempt==1 && @scores[-1].points<10)
           return "two attempts in the same frame cannot surpass the 10 points" if @scores[-1].points+points>10
           @scores.push(Score.new(points, @scores[-1].frame, 2))
        elsif
           @scores.push(Score.new(points, @scores[-1].frame+1, 1))
        end
    elsif @scores[-1].frame==10 && (@scores[-1].attempt==3 || (@scores[-1].attempt==2 && @scores[-1].points+@scores[-2].points<10))
        return "current player didn't have more attempts or frames available"
    else
        @scores.push(Score.new(points, 10, @scores[-1].frame==9 ? 1 : @scores[-1].attempt+1))
    end
    global_game_score if @scores[-1].frame==10 && (@scores[-1].attempt==3 || @scores[-1].points+@scores[-2].points<10)
    return ""
  end

  private 

  def global_game_score
    (0...@scores.length).each do |i|
      current_score= @scores[i].frame==1 ? 0 : @global_scores[@scores[i].frame-1]
      if(@scores[i].frame<10)
        if @scores[i].frame<@scores[i+1].frame
          if @scores[i].attempt==1
            @global_scores[@scores[i].frame]=@scores[i].points+@scores[i+1].points+@scores[i+2].points+current_score
          elsif @scores[i].attempt==2 && (@scores[i-1].points+@scores[i].points==10)
            @global_scores[@scores[i].frame]=@scores[i-1].points+@scores[i].points+@scores[i+1].points+current_score
          else
            @global_scores[@scores[i].frame]=@scores[i-1].points+@scores[i].points+current_score
          end
        end
      elsif @scores[i].frame==10 && @scores[i].attempt==1
        @global_scores[@scores[i].frame]=@scores[i].points+@scores[i+1].points+(@scores[i+2].nil? ? 0 : @scores[i+2].points)+current_score
      end
    end
  end
end
