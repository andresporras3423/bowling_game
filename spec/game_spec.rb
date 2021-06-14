require_relative '../lib/game'
require 'rspec'

RSpec.describe Game do
  describe 'tests file content' do
    it 'test invalid content by score which is not a number' do
      (expect do
        Game.new('./../spec/data_test/out_of_range_score.txt', true)
      end
      ).to output("Score should be an integer between 1 and 10\n").to_stdout
    end
  end
end
