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
  attr_reader :color
  def initialize(pos, color)
    @board = nil
    @pos = pos
    @color = color
  end

  def to_s
    TYPES[@type]
  end

  def moves
  end
end

class SlidingPiece < Piece
  def moves(direction)
    possible_moves = []

    1.upto(7) do |i|
      if direction.include?(:diagonal)
        possible_moves << [@pos[0] + i, @pos[1] + i]
        possible_moves << [@pos[0] - i, @pos[1] - i]
        possible_moves << [@pos[0] - i, @pos[1] + i]
        possible_moves << [@pos[0] + i, @pos[1] - i]
      end

      if direction.include?(:horizontal_vertical)
        possible_moves << [@pos[0], @pos[1] + i]
        possible_moves << [@pos[0], @pos[1] - i]
        possible_moves << [@pos[0] + i, @pos[1]]
        possible_moves << [@pos[0] - i, @pos[1]]
      end
    end
    in_bound_moves = possible_moves.select { |move| @board.in_bounds?(move) }
    in_bound_moves.select { |move| @board[move].piece.color != @color }
  end
end

class SteppingPiece < Piece
end

class King < SteppingPiece
  def initialize(pos, color)
    super
    @type = :king
    @move_dirs = [:king_move]
  end

  def moves
    super(@move_dirs)
  end
end

class Knight < SteppingPiece
  def initialize(pos, color)
    super
    @type = :knight
    @move_dirs = [:knight_move]
  end

  def moves
    super(@move_dirs)
  end
end

class Pawn < SteppingPiece
  def initialize(pos, color)
    super
    @type = :pawn
    @move_dirs = [:pawn_move]
  end

  def moves
    super(@move_dirs)
  end
end


class Bishop < SlidingPiece
  def initialize(pos, color)
    super
    @type = :bishop
    @move_dirs = [:diagonal]
  end

  def moves
    super(@move_dirs)
  end
end

class Rook < SlidingPiece
  def initialize(pos, color)
    super
    @type = :rook
    @move_dirs = [:horizontal_vertical]
  end

  def moves
    super(@move_dirs)
  end
end

class Queen < SlidingPiece
  def initialize(pos, color)
    super
    @type = :queen
    @move_dirs = [:diagnoal, :horizontal_vertical]
  end

  def moves
    super(@move_dirs)
  end
end

class NullPiece < Piece
  # include Singleton
  def initialize
    @type = :null
  end

  # def to_s
  #   "   "
  # end
end
