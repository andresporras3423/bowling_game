# frozen_string_literal: true

require_relative '../lib/player'
require 'rspec'

RSpec.describe Player do
  let(:player1) { Player.new('player1') }
  describe 'read file content' do
    it 'sum of two values in the same frame cannot be bigger than 10' do
      player1.add_score(7)
      expect(player1.add_score(6)).to eql('two attempts in the same frame cannot surpass the 10 points')
    end
    it 'test player exceed limit number of attempts after complete all the game with pefect score' do
      12.times { player1.add_score(10) }
      expect(player1.add_score(10)).to eql("current player didn't have more attempts or frames available")
    end
    it 'test player exceed limit number of attempts after complete all the game with 0 scores in every attempt' do
      20.times { player1.add_score(0) }
      expect(player1.add_score(0)).to eql("current player didn't have more attempts or frames available")
    end
  end
end
