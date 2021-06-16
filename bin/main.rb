# frozen_string_literal: true

require_relative '../lib/Game'
puts 'type the relative path to the file with the game data:'
relative_path = gets.chomp # use the next valid file:../data/scores.txt
Game.new(relative_path, true)
