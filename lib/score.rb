# frozen_string_literal: true

# score information
class Score
  attr_reader :points, :frame, :attempt

  def initialize(points, frame, attempt)
    @points = points
    @frame = frame
    @attempt = attempt
  end
end
