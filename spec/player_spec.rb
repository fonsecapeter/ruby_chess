require 'rspec'
require 'player'
require_relative '../lib/constants'

describe Player do
  let (:board) { double("board") }
  subject(:player) { Player.new(board, :magenta, CONSTANTS[:white]) }

  describe "#initialize" do
    it "initializes the player's display color" do
      expect(player.color).to eq(:magenta)
    end
  end

  describe "#get_move" do
    it "does not allow the player to try to move a null piece"
    it "does not allow the player to try to move a piece with no valid moves"
    it "does not allow the player to try to move a piece from the other team"
  end
end
