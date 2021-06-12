# frozen_string_literal: true

require_relative 'player'

class Game
  attr_reader :players

  def initialize(relative_path)
    @players = {}
    absolute_path = File.join(File.dirname(__FILE__), relative_path)
    content_file = File.open(absolute_path)
    files_lines = content_file.read
    files_lines.each_line do |line|
      scoreData = line.split(' ')
      player_name = scoreData[0]
      player_score = scoreData[1]
      @players[player_name] = Player.new(player_name) if @players[player_name].nil?
      @players[player_name].scores.push(player_score)
    end
    content_file.close
    @players.each_value do |player|
      p player.name
    end
  end
end
