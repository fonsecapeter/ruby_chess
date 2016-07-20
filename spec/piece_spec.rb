require 'rspec'
require 'pieces/piece'
require_relative '../lib/constants'

describe Piece do
  let(:clr) { CONSTANTS[:white] }
  let(:pos) { [0, 0] }
  let(:board) { double("board") }
  let(:board_copy) { double("board") }
  subject(:piece) { Rook.new(pos, clr) }

  describe "#initialize" do
    it "initializes the piece's position" do
      expect(piece.pos).to eq(pos)
    end

    it "initializes the piece's color" do
      expect(piece.color).to eq(CONSTANTS[:white])
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


  context"when integrated with a board" do
    let (:real_board) { Board.new }
    before(:each) { real_board.populate }

    describe "#valid_moves" do
      it "will not allow a move that puts the piece's team in check" do
        real_board.move([0, 4], [4, 4])
        expect(real_board[[4, 4]].valid_moves(real_board)).to_not include([5, 4])
      end
    end

    describe "#move" do
      before(:each) { real_board[[0, 0]].move(real_board, [4, 4]) }

      it "moves a piece to the desired location" do
        expect(real_board[[4, 4]]).to be_a(Rook)
      end
      it "sets the piece's previous location to a null piece" do
        expect(real_board[[0, 0]]).to be_a(NullPiece)
      end
      it "does not think it moved" do
        expect(real_board[[4, 4]].pos).to eq([0, 0])
      end
    end

    describe "#move!" do
      before(:each) { real_board[[0, 0]].move!(real_board, [4, 4]) }

      it "moves a piece to the desired location" do
        expect(real_board[[4, 4]]).to be_a(Rook)
      end

      it "sets the piece's previous location to a null piece" do
        expect(real_board[[0, 0]]).to be_a(NullPiece)
      end

      it "the piece knows that it moved" do
        expect(real_board[[4, 4]].pos).to eq([4, 4])
      end
    end
  end
end
