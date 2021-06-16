# frozen_string_literal: true

require_relative 'player'
require_relative 'valid_score'
# Game information
class Game
  include ValidScore
  attr_reader :players

  def initialize(relative_path, request_output)
    @players = {}
    error_message = read_file_content(relative_path)
    if error_message != ''
      puts error_message
      return
    end
    give_output if request_output
  end

  private

  def give_output
    output = "Frame     1     2     3     4     5     6     7     8     9     10\n"

    @players.each_value do |player|
      if player.global_scores[1] == -1
        puts "Incomplete data, #{player.name} hasn't completed its game"
        return
      end
      name = player.name
      pinfalls = print_player_pinfalls(player)
      scores = print_player_score(player)
      output += "#{name}\n"
      output += "#{pinfalls}\n"
      output += "#{scores}\n"
    end
    puts output
  end

  def print_player_pinfalls(player)
    pinfalls = 'Pinfalls'
    (0...player.scores.length).each do |i|
      pinfalls += if player.scores[i].frame < 10
                    pinfalls_before_frame_ten(player, i)
                  else
                    pinfalls_frame_ten(player, i)
                  end
    end
    pinfalls
  end

  def pinfalls_before_frame_ten(player, i)
    if player.scores[i].roll == 1 && @@valid_score[player.scores[i].points] == 10
      return '     X'
    elsif @@valid_score[player.scores[i].points] == 10
      return '  X'
    elsif player.scores[i].roll == 2 && @@valid_score[player.scores[i - 1].points] + @@valid_score[player.scores[i].points] == 10
      return '  /'
    end

    "  #{player.scores[i].points}"
  end

  def pinfalls_frame_ten(player, i)
    if @@valid_score[player.scores[i].points] == 10
      return '  X'
    elsif (player.scores[i].roll == 2 && @@valid_score[player.scores[i - 1].points] < 10 && @@valid_score[player.scores[i - 1].points] + @@valid_score[player.scores[i].points] == 10) ||
          (player.scores[i].roll == 3 && @@valid_score[player.scores[i - 2].points] == 10 && @@valid_score[player.scores[i - 1].points] < 10 && @@valid_score[player.scores[i - 1].points] + @@valid_score[player.scores[i].points] == 10)
      return '  /'
    end

    "  #{player.scores[i].points}"
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
    return "Every line should contain two values, the player's name and the pinfalls" if score_data.length != 2

    player_name = score_data[0]
    player_score = @@valid_score[score_data[1]]
    return 'Score should be an integer between 1 and 10' if player_score.nil?

    @players[player_name] = Player.new(player_name) if @players[player_name].nil?
    @players[player_name].add_score(score_data[1])
  end
end
