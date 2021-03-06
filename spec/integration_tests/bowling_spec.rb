# frozen_string_literal: true

require_relative '../../lib/game'
require 'rspec'

RSpec.describe Game do
  describe 'read file content' do
    before(:each) do
      @output = "Frame     1     2     3     4     5     6     7     8     9     10\n"
    end
    it 'test red valid content with two players' do
      @output += "Jeff\n"
      @output += "Pinfalls     X  7  /  9  0     X  0  8  8  /  F  6     X     X  X  8  1\n"
      @output += "Scores    20    39    48    66    74    84    90    120   148   167\n"
      @output += "John\n"
      @output += "Pinfalls  3  /  6  3     X  8  1     X     X  9  0  7  /  4  4  X  9  0\n"
      @output += "Scores    16    25    44    53    82    101   110   124   132   151\n"
      (expect do
        Game.new('./../spec/data_test/valid_score1.txt', true)
      end
      ).to output(@output).to_stdout
    end
    it 'test valid file content with three players' do
      @output += "player1\n"
      @output += "Pinfalls     X     X     X     X     X     X     X     X     X  X  X  X\n"
      @output += "Scores    30    60    90    120   150   180   210   240   270   300\n"
      @output += "player2\n"
      @output += "Pinfalls  5  /  5  /  5  /  5  /  5  /  5  /  5  /  5  /  5  /  5  /  5\n"
      @output += "Scores    15    30    45    60    75    90    105   120   135   150\n"
      @output += "player3\n"
      @output += "Pinfalls  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0\n"
      @output += "Scores    0     0     0     0     0     0     0     0     0     0\n"
      (expect do
        Game.new('./../spec/data_test/valid_score2.txt', true)
      end
      ).to output(@output).to_stdout
    end
    it 'test valid file content with only one player who fails in every roll' do
      @output += "Oscar\n"
      @output += "Pinfalls  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F\n"
      @output += "Scores    0     0     0     0     0     0     0     0     0     0\n"
      (expect do
        Game.new('./../spec/data_test/valid_score3.txt', true)
      end
      ).to output(@output).to_stdout
    end
    it 'Test spare in the second roll of the tenth frame' do
      @output += "andres\n"
      @output += "Pinfalls  4  /  4  /  4  /  4  /  4  /  4  /  4  /  4  /  4  /  4  /  8\n"
      @output += "Scores    14    28    42    56    70    84    98    112   126   144\n"
      (expect do
        Game.new('./../spec/data_test/valid_score4.txt', true)
      end
      ).to output(@output).to_stdout
    end
    it 'Test spare in the third roll of the tenth frame' do
      @output += "andres\n"
      @output += "Pinfalls  4  /  4  /  4  /  4  /  4  /  4  /  4  /  4  /  4  /  X  6  /\n"
      @output += "Scores    14    28    42    56    70    84    98    112   132   152\n"
      (expect do
        Game.new('./../spec/data_test/valid_score5.txt', true)
      end
      ).to output(@output).to_stdout
    end
    it 'interleving rols with zero pinfalls and 10 pinfalls' do
      @output += "andres\n"
      @output += "Pinfalls  F  X  F  X  F  X  F  X  F  X  F  X  F  X  F  X  F  X  F  X  X\n"
      @output += "Scores    10    20    30    40    50    60    70    80    90    110\n"
      (expect do
        Game.new('./../spec/data_test/valid_score6.txt', true)
      end
      ).to output(@output).to_stdout
    end
  end
end
