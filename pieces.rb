require 'singleton'

class Piece
  TYPES = {
    :null => "   ",
    :king => " \u265A ".encode('utf-8'),
    :queen => " \u265B ".encode('utf-8'),
    :bishop => " \u265D ".encode('utf-8'),
    :knight => " \u265E ".encode('utf-8'),
    :rook => " \u265C ".encode('utf-8'),
    :pawn => " \u265F ".encode('utf-8'),
  }
  attr_reader :color, :pos, :type
  def initialize(pos, color)
    @pos = pos
    @color = color
  end

  def to_s
    TYPES[@type]
  end

  def moves(board)
    # give us all possible moves that are:
    #   a.) on the board
    #   b.) not onto another piece of my color
    []
  end

  def valid_moves(board)
    # takes all of my moves and only gives back those that do not
    # put my color in check
    valid_moves = []
    moves(board).each do |pos|
      board_copy = board.dup
      move(board_copy, pos)

      valid_moves << pos unless board_copy.in_check?(@color)
    end
    valid_moves
  end

  def move(board, new_pos)
    starting_pos = @pos
    board[new_pos] = self
    board[starting_pos] = NullPiece.instance
  end

  def move!(board, new_pos)
    starting_pos = @pos
    board[new_pos] = self
    board[starting_pos] = NullPiece.instance
    @pos = new_pos
  end
end

class SlidingPiece < Piece
  def moves(board)
    possible_moves = []

    if @move_dirs.include?(:diagonal)
      slide(possible_moves, board) { |i| [@pos[0] + i, @pos[1] + i] }
      slide(possible_moves, board) { |i| [@pos[0] + i, @pos[1] - i] }
      slide(possible_moves, board) { |i| [@pos[0] - i, @pos[1] + i] }
      slide(possible_moves, board) { |i| [@pos[0] - i, @pos[1] - i] }
    end

    if @move_dirs.include?(:horizontal_vertical)
      # horizontal
      slide(possible_moves, board) { |i| [@pos[0], @pos[1] + i] }
      slide(possible_moves, board) { |i| [@pos[0], @pos[1] - i] }
      # vert
      slide(possible_moves, board) { |i| [@pos[0] + i, @pos[1]] }
      slide(possible_moves, board) { |i| [@pos[0] - i, @pos[1]] }
    end

    possible_moves

  end

  private
  def slide(possible_moves, board, &prc)
    1.upto(7) do |i|
      possible_pos = prc.call(i)

      if board.in_bounds?(possible_pos)
        possible_moves << possible_pos if board[possible_pos].color != @color
        if board[possible_pos].is_a?(NullPiece) == false
          break
        end
      end

    end
  end

end

class SteppingPiece < Piece
  def moves(board)
    possible_moves = []

    if @move_dirs.include?(:king_move)
      [-1,0,1].each do |i|
        [-1,0,1].each do |j|
          possible_moves << [@pos[0] + i, @pos[1] + j]
        end
      end
    end

    if @move_dirs.include?(:knight_move)
      [-1,1].each do |one|
        [-2,2].each do |two|
          possible_moves << [@pos[0] + one, @pos[1] + two]
          possible_moves << [@pos[0] + two, @pos[1] + one]
        end
      end
    end
    in_bound_moves = possible_moves.select { |move| board.in_bounds?(move) }
    in_bound_moves.select { |move| board[move].color != @color }
   end
end

class King < SteppingPiece
  def initialize(pos, color)
    super
    @type = :king
    @move_dirs = [:king_move]
  end

end

class Knight < SteppingPiece
  def initialize(pos, color)
    super
    @type = :knight
    @move_dirs = [:knight_move]
  end

end

class Pawn < Piece
  def initialize(pos, color)
    super
    @type = :pawn
    @move_dirs = [:pawn_move]
  end

  def moves(board)
    @board = board

    if @color == :white
      i = 1
    else
      i = -1
    end

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


class Bishop < SlidingPiece
  def initialize(pos, color)
    super
    @type = :bishop
    @move_dirs = [:diagonal]
  end

end

class Rook < SlidingPiece
  def initialize(pos, color)
    super
    @type = :rook
    @move_dirs = [:horizontal_vertical]
  end

end

class Queen < SlidingPiece
  def initialize(pos, color)
    super
    @type = :queen
    @move_dirs = [:diagonal, :horizontal_vertical]
  end

end

class NullPiece < Piece
  include Singleton

  def initialize
    @type = :null
    @color = :null
  end

  def dup
    NullPiece.instance
  end

end
