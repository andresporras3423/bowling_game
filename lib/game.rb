# frozen_string_literal: true

require_relative 'player'
# Game information
class Game
  attr_reader :players

  def initialize(relative_path)
    error_message = read_file_content(relative_path)
    if error_message != ''
      puts error_message
      return
    end
    give_output
  end

  private

  def give_output
    puts 'Frame     1     2     3     4     5     6     7     8     9     10'
    @players.each_value do |player|
      name = player.name
      pinfalls = print_player_pinfalls(player)
      scores = print_player_score(player)
      puts name
      puts pinfalls
      puts scores
    end
  end

  def print_player_pinfalls(player)
    pinfalls = 'Pinfalls'
    player.scores.each_with_index do |score, i|
      pinfalls += if score.points < 10 && (score.attempt == 1 || score.attempt == 3)
                    "  #{score.points}"
                  elsif score.points == 10 && score.frame == 10
                    '  X'
                  elsif score.points == 10
                    '     X'
                  elsif score.points < 10 && player.scores[i - 1].points + score.points == 10
                    '  /'
                  else
                    "  #{score.points}"
                  end
    end
    pinfalls
  end

  def print_player_score(player)
    scores = 'Scores'
    player.global_scores.each do |key, value|
      scores += if key == 1
                  "    #{value}"
                else
                  (' ' * (6 - player.global_scores[key - 1].to_s.split('').length)) + value.to_s
                end
    end
    scores
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
    score_data = line.split(' ')
    player_name = score_data[0]
    player_score = @valid_options[score_data[1]]
    return 'Score should be an integer between 1 and 10' if player_score.nil?

    @players[player_name] = Player.new(player_name) if @players[player_name].nil?
    message = @players[player_name].add_score(player_score)
    return message if message != ''

    ''
  end
end
