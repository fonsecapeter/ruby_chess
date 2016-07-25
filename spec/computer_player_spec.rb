require 'rspec'
require 'computer_player'
require_relative '../lib/constants'
require 'board'

# pretty much all implementation level integration tests
describe ComputerPlayer do
  let(:b) { Board.new.populate }
  let(:d) { double("d") }
  subject(:ai) { ComputerPlayer.new(b, CONSTANTS[:green], CONSTANTS[:white], d) }

  describe "#get_move" do
    it "pickes a move" do
      allow(d).to receive(:selected=)
      expect(ai.get_move(b).length).to eq(2)
    end
  end

  context "when evaluating moves" do
    before(:each) { ai.send(:get_valid_moves) }

    describe "#pick_valuable_move" do
      it "returns a move" do
        expect(ai.send(:pick_valuable_move).length).to eq(2)
      end
    end

    describe "#get_valid_moves" do
      it "returns a list of valid moves" do
        expect(ai.send(:valid_moves).empty?).to be_falsey
      end
    end

    describe "#checkmates" do
      it "identifies a potential check mate" do
        b.move([6, 0], [5, 0]) # eliminate future threat to wqueen
        b.move([6, 1], [4, 1]) # eliminate future threat to wqueen
        b.move([6, 2], [4, 2]) # expose bking
        b.move([0, 3], [1, 3]) # position wqeen
        ai.send(:get_valid_moves)
        expect(ai.send(:checkmates)).to include([[1, 3], [4, 0]])
      end
    end

    describe "#checks" do
      it "identifies a potential check" do
        b.move([6, 2], [5, 2]) # expose bking
        b.move([0, 3], [4, 1]) # position wqueen
        ai.send(:get_valid_moves)
        expect(ai.send(:checks)).to include([[4, 1], [4, 0]])
      end
    end

    describe "#attacks" do
      it "identifies a potential attack" do
        b.move([1, 0], [5, 0]) # move wpawn near bpawn
        ai.send(:get_valid_moves)
        expect(ai.send(:attacks)).to eq([[[5, 0], [6, 1]]])
      end

      it "prioritizes order on piece value" do
        b.move([7, 0], [6, 0]) # move brook near bpawn
        b.move([1, 1], [5, 1]) # move wpawn near bpawn
        ai.send(:get_valid_moves)
        expect(ai.send(:attacks)).to eq([
          [[5, 1], [6, 0]], # rook
          [[5, 1], [6, 2]]  # pawn
        ])
        # swap position of brook and bpawn and expect order to be same
        b.move([6, 0], [4, 0]) # move move brook out of the way
        b.move([6, 2], [6, 0]) # move bpawn to previous brook position
        b.move([4, 0], [6, 2]) #move brook to previous bpawn position
        expect(ai.send(:attacks)).to eq([
          [[5, 1], [6, 2]], # rook
          [[5, 1], [6, 0]]  # pawn
          ])
      end
    end
  end
end
