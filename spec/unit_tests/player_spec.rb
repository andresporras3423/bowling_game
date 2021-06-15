# frozen_string_literal: true

require_relative '../../lib/player'
require 'rspec'

RSpec.describe Player do
  let(:player1) { Player.new('player1') }
  describe 'read file content' do
    it 'Before frame 10, sum of two values in the same frame cannot be bigger than 10' do
      player1.add_score(7)
      expect(player1.add_score(6)).to eql('Before frame 10, two attempts in the same frame cannot surpass the 10 points')
    end
    it 'In frame 10, player cannot surpass ten points in the first two attempts when it did not get a strike in the fist attempt' do
      19.times { player1.add_score(5) }
      expect(player1.add_score(6)).to eql('On the tenth frame, first and second attempt cannot surpass 10 points unless the first attempt were a strike')
    end
    it 'In frame 10, player cannot surpass ten points in the first two attempts when it did not get a strike in the fist attempt' do
      18.times { player1.add_score(5) }
      player1.add_score(10)
      player1.add_score(5)
      expect(player1.add_score(6)).to eql('On the tenth frame, second and third attempt cannot surpass 10 points when the first attempt was a strike but the second was not a strike')
    end
    it 'test player exceed limit number of attempts after complete all the game with pefect score' do
      12.times { player1.add_score(10) }
      expect(player1.add_score(10)).to eql("current player didn't have more attempts or frames available")
    end
    it 'test player exceed limit number of attempts after complete all the game with 0 scores in every attempt' do
      20.times { player1.add_score(0) }
      expect(player1.add_score(0)).to eql("current player didn't have more attempts or frames available")
    end
    it 'test player complete game after scoring 5 in 21 attempts' do
      20.times { player1.add_score(5) }
      expect(player1.add_score(5)).to eql('')
    end
  end
end
