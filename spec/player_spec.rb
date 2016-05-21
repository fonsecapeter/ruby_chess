require 'rspec'
require 'player'

describe Player do
  let (:board) { double("board") }
  subject(:player) { Player.new(board, :magenta, :white) }

  describe "#initialize" do
    it "initializes the player's display color" do
      expect(player.color)
    end

    it "initializes the player's team"
    it "initializes the player's display"
  end

  describe "#get_move" do
    it "does not allow the player to try to move a null piece"
    it "does not allow the player to try to move a piece with no valid moves"
    it "does not allow the player to try to move a piece from the other team"
  end
end
