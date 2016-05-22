require 'rspec'
require 'pieces/piece'

describe Piece do
  let(:clr) { :white }
  let(:pos) { [0, 0] }
  let(:board) { double("board") }
  let(:board_copy) { double("board") }
  subject(:piece) { Rook.new(pos, clr) }

  describe "#initialize" do
    it "initializes the piece's position" do
      expect(piece.pos).to eq(pos)
    end

    it "initializes the piece's color" do
      expect(piece.color).to eq(:white)
    end
  end

  describe "#moves" do
    it "always outputs an array" do
      allow(board).to receive(:[]=)
      allow(board).to receive(:[]).and_return(NullPiece.instance)
      allow(board).to receive(:in_bounds?).and_return(true)
      expect(piece.moves(board)).to be_an(Array)
    end
  end


  # integration tests
  # --------------------------------------------------------------------
  let (:real_board) { Board.new }
  before(:each) { real_board.populate }

  describe "valid_moves" do
    it "will not allow a move that puts the piece's team in check"
    real_board.move[[0, 4], []]
  end

  describe "#move" do
    it "moves a piece to the desired location"
    it "sets the piece's previous location to a null piece"
    it "the piece does not think it moved"
  end

  describe "#move!" do
    it "moves a piece to the desired location"
    it "sets the piece's previous location to a null piece"
    it "the piece knows that it moved"
  end
end
