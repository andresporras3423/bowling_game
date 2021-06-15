# frozen_string_literal: true

# score information
class Score
  attr_reader :points, :frame, :roll

  def initialize(points, frame, roll)
    @points = points
    @frame = frame
    @roll = roll
  end
end
