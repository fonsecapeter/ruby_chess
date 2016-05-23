require 'rspec'
require 'pieces/sliding_piece'

describe SlidingPiece do

  context "when integrated with a board" do
    let (:real_board) { Board.new }
    before(:each) { real_board.populate }

    describe "#moves" do
      it "doesn't allow the piece to move off the board" do
        expect(real_board[[0, 0]].moves(real_board)).to_not include([-1, 0])
      end

      it "stops sliding when interrupted by another piece" do
        real_board.move([1, 0], [2, 0])
        expect(real_board[[0, 0]].moves(real_board)).to include([1, 0])
        expect(real_board[[0, 0]].moves(real_board)).to_not include([3, 0])
      end

      it "doesn't include moves into pieces of the same team" do
        real_board.move([1, 0], [2, 0])
        expect(real_board[[0, 0]].moves(real_board)).to_not include([2, 0])
      end

      it "includes moves into pieces of the opposite team" do
        real_board.move([0, 0], [2, 0])
        expect(real_board[[2, 0]].moves(real_board)).to include([6, 0])
      end
    end
  end
end
