require_relative '../constants'

class Pawn < Piece
  def initialize(pos, color)
    super
    @type = :pawn
    @move_dirs = [:pawn_move]
  end

  def moves(board)
    @board = board
    @color == CONSTANTS[:white] ? i = 1 : i = -1

    possible_moves = []
    first_move = [@pos[0] + i, @pos[1]]
    possible_moves << first_move if @board.in_bounds?(first_move) &&
      @board[first_move].is_a?(NullPiece)

    if i == 1 && @pos[0] == 1
      move = [@pos[0] + 2, @pos[1]]
      possible_moves << move if @board[move].is_a?(NullPiece)
    elsif i == -1 && @pos[0] == 6
      move = [@pos[0] - 2, @pos[1]]
      possible_moves << move if @board[move].is_a?(NullPiece)
    end

    possible_attacks = []
    possible_attacks << [@pos[0] + i, @pos[1] + 1]
    possible_attacks << [@pos[0] + i, @pos[1] - 1]

    valid_attacks = possible_attacks.select do |move|
      @board.in_bounds?(move) &&
        @board[move].color != @color &&
        !@board[move].is_a?(NullPiece)
    end

    possible_moves += valid_attacks
    possible_moves.select { |move| @board[move].color != @color }
  end
end
