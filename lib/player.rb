# frozen_string_literal: true

class Player
  attr_reader :name
  attr_accessor :total_score, :scores

  def initialize(name)
    @name = name
    @total_score = 0
    @scores = []
  end
end
