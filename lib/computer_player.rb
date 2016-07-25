require_relative 'player.rb'

class ComputerPlayer < Player
  def initialize(board, color, team, display = {})
    super
    @priorities = {
      Queen: 5,
      Rook: 4,
      Bishop: 3,
      Knight: 2,
      Pawn: 1,
      NullPiece: 0
    }
  end

  private

  def get_moveable_pieces
    @moveable_pieces = @board.pieces(@team)
      .select { |piece| piece.valid_moves.any? }
  end

  def inspect_piece_moves
    possible_moves = []
    @moveable_pieces.each do |piece|
      piece.valid_moves.each { |move| possible_moves << [piece.pos, move] }
    end
    possible_moves
  end
end
