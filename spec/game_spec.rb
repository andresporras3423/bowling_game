require_relative '../lib/game'
require 'rspec'

RSpec.describe Game do
  describe 'read file content' do
    it 'test invalid content by score which is not a number' do
      (expect do
        Game.new('./../spec/data_test/invalid_score1.txt', true)
      end
      ).to output("Score should be an integer between 1 and 10\n").to_stdout
    end
    it 'test invalid content by score which is a number below 0' do
      (expect do
        Game.new('./../spec/data_test/invalid_score2.txt', true)
      end
      ).to output("Score should be an integer between 1 and 10\n").to_stdout
    end
    it 'test invalid content by score which is a number above 10' do
      (expect do
        Game.new('./../spec/data_test/invalid_score3.txt', true)
      end
      ).to output("Score should be an integer between 1 and 10\n").to_stdout
    end
    it 'test invalid content by a line with only one word' do
      (expect do
        Game.new('./../spec/data_test/invalid_score4.txt', true)
      end
      ).to output("Every line should contain two values, the player's name and the pinfalls\n").to_stdout
    end
    it 'test invalid content by a line with only three words' do
      (expect do
        Game.new('./../spec/data_test/invalid_score5.txt', true)
      end
      ).to output("Every line should contain two values, the player's name and the pinfalls\n").to_stdout
    end
  end
end
