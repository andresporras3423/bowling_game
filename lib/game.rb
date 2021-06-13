# frozen_string_literal: true

require_relative 'player'

class Game
  attr_reader :players

  def initialize(relative_path)
    error_message = read_file_content(relative_path)
    if error_message != ''
      puts error_message
      return
    end
    output = []
    @players.each_value do |player|
      puts "Player name: #{player.name}"
      player.scores.each do |score|
        puts "frame: #{score.frame}, attempt: #{score.attempt}, point: #{score.points}, total score: #{player.global_scores[score.frame]}"
      end
    end
  end

  def read_file_content(relative_path)
    @valid_options = (0..10).map { |i| [i.to_s, i] }.to_h
    @valid_options['F'] = 0
    @players = {}
    absolute_path = File.join(File.dirname(__FILE__), relative_path)
    content_file = File.open(absolute_path)
    files_lines = content_file.read
    files_lines.each_line do |line|
      error_message = add_line_content(line)
      return error_message if error_message != ''
    end
    content_file.close
    ''
  end

  def add_line_content(line)
    scoreData = line.split(' ')
    player_name = scoreData[0]
    player_score = @valid_options[scoreData[1]]
    return 'Score should be an integer between 1 and 10' if player_score.nil?

    @players[player_name] = Player.new(player_name) if @players[player_name].nil?
    message = @players[player_name].add_score(player_score)
    return message if message != ''

    ''
  end
end
