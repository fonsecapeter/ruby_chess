require 'rspec'
require 'board'
require_relative '../lib/constants'

describe Board do
  subject(:b) { Board.new }
  let(:pos) { [0, 0] }
  let(:rook) { double("rook", valid_moves: [7, 4]) }

  describe "#initialize" do
    it "initializes an 8x8 grid" do
      expect(b.grid.size).to eq(8)
      expect(b.grid[0].size).to eq(8)
    end
  end

  describe "#[]" do
    it "returns the piece at that position in the grid" do
      expect(b[pos]).to be(b.grid[pos.first][pos.last])
    end
  end

  describe "#[]=" do
    it "sets the piece at that position in the grid" do
      b[pos] = rook
      expect(b.grid[pos.first][pos.last]).to be(rook)
    end
  end

  describe "#populate" do
    before(:each) { b.populate }

    it "has rooks" do
      expect(b[[0, 0]]).to be_a(Rook)
      expect(b[[0, 7]]).to be_a(Rook)
      expect(b[[7, 0]]).to be_a(Rook)
      expect(b[[7, 7]]).to be_a(Rook)
    end

    it "has knights" do
      expect(b[[0, 1]]).to be_a(Knight)
      expect(b[[0, 6]]).to be_a(Knight)
      expect(b[[7, 1]]).to be_a(Knight)
      expect(b[[7, 6]]).to be_a(Knight)
    end

    it "has bishops" do
      expect(b[[0, 2]]).to be_a(Bishop)
      expect(b[[0, 5]]).to be_a(Bishop)
      expect(b[[7, 2]]).to be_a(Bishop)
      expect(b[[7, 5]]).to be_a(Bishop)
    end

    it "has kings" do
      expect(b[[0, 4]]).to be_a(King)
      expect(b[[7, 3]]).to be_a(King)
    end

    it "has queens" do
      expect(b[[0, 3]]).to be_a(Queen)
      expect(b[[7, 4]]).to be_a(Queen)
    end

    it "has pawns" do
      expect(b[[1, 3]]).to be_a(Pawn)
      expect(b[[6, 4]]).to be_a(Pawn)
    end

    it "picks teams" do
      expect(b[[1, 3]].color).to eq(CONSTANTS[:white])
      expect(b[[7, 6]].color).to eq(CONSTANTS[:black])
    end
  end

  describe "#in_bounds?" do
    it "accepts coordinates on the board" do
      expect(b.in_bounds?([3, 7])).to be_truthy
    end

    it "rejects coordinates that are too large" do
      expect(b.in_bounds?([6, 8])).to be_falsey
    end

    it "rejects negative number" do
      expect(b.in_bounds?([-1, 2])).to be_falsey
    end
  end

  describe "#move" do
    before(:each) { b.populate }

    it "moves a piece on the board" do
      b.move([0, 0], [4, 4])
      expect(b[[4, 4]]).to be_a(Rook)
      expect(b[[0, 0]]).to be_a(NullPiece)
    end
  end

  describe "#in_check?" do
    before(:each) { b.populate }

    it "doesn't throw a false-positive" do
      expect(b.in_check?(CONSTANTS[:white])).to be_falsey
      expect(b.in_check?(CONSTANTS[:black])).to be_falsey
    end

    it "recognizes a threat to the king" do
      b.move([0, 0], [3, 4])
      b.move([7, 3], [5, 4])
      expect(b.in_check?(CONSTANTS[:black])).to be_truthy
      expect(b.in_check?(CONSTANTS[:white])).to be_falsey
    end
  end

  describe "#checkmate?" do
    before(:each) { b.populate }

    it "doesn't throw a false-positive" do
      expect(b.checkmate?(CONSTANTS[:white])).to be_falsey
      expect(b.checkmate?(CONSTANTS[:black])).to be_falsey
    end

    it "recognizes an inescapable threat to the king" do
      b.move([6, 0], [5, 0]) # eliminate future threat to wqueen
      b.move([6, 1], [4, 1]) # eliminate future threat to wqueen
      b.move([6, 2], [4, 2]) # expose bking
      b.move([0, 3], [4, 0]) # position wqeen
      expect(b.checkmate?(CONSTANTS[:black])).to be_truthy
      expect(b.checkmate?(CONSTANTS[:white])).to be_falsey
    end
  end

  describe "#pieces" do
    before(:each) { b.populate }

    it "returns all pieces" do
      expect(b.pieces.count).to eq(32)
    end

    it "ignores NullPieces" do
      expect(b.pieces.any? { |piece| piece.type == :null }).to be_falsey
    end

    it "can take an optional team and only return those pieces" do
      expect(b.pieces(CONSTANTS[:white]).count).to eq(16)
    end
  end
end
