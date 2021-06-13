# frozen_string_literal: true

require_relative 'score'

class Player
  attr_reader :name
  attr_accessor :total_score, :scores

  def initialize(name)
    @name = name
    @total_score = 0
    @scores = []
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
    return ""
  end
end
