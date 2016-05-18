class Pawn < Piece
  def initialize(pos, color)
    super
    @type = :pawn
    @move_dirs = [:pawn_move]
  end

  def moves(board)
    @board = board
    @color == :white ? i = 1 : i = -1

    possible_moves = []
    possible_moves << [@pos[0] + i, @pos[1]] if @board.in_bounds?([@pos[0] + i, @pos[1]]) && @board[[@pos[0] + i, @pos[1]]].is_a?(NullPiece)

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
