require 'rspec'
require 'pieces/stepping_piece'

describe SteppingPiece do

  context "when integrated with a board" do
    let (:real_board) { Board.new }
    before(:each) { real_board.populate }

    describe "#moves" do
      it "doesn't allow the piece to move off the board" do
        expect(real_board[[0, 4]].moves(real_board)).to_not include([-1, 4])
      end

      it "allows the knight to move over other pieces" do
        expect(real_board[[0, 1]].moves(real_board)).to include([2, 2])
      end

      it "doesn't include moves into pieces of the same team" do
        expect(real_board[[0, 4]].moves(real_board)).to_not include([1, 4])
      end

      it "includes moves into pieces of the opposite team" do
        real_board.move([0, 1], [4, 1])
        expect(real_board[[4, 1]].moves(real_board)).to include([6, 2])
      end
    end
  end
end
