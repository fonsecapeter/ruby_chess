require_relative 'pieces_manifest'
require_relative 'constants'

class Board
  attr_reader :grid
  def initialize(grid = Array.new(8) { Array.new(8) { NullPiece.instance } })
    @grid = grid
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end

  def in_bounds?(pos)
    pos.all? { |coordinate| coordinate.between?(0, 7) }
  end

  def in_check?(color)
    our_king = find_king(color)

    @grid.each do |row|
      row.each do |piece|
        unless piece.color == color && piece.is_a?(NullPiece)
          return true if piece.moves(self).include?(our_king.pos)
        end
      end
    end

    false
  end

  def checkmate?(color)
    # must be in_check to have checkmate
    if in_check?(color)
      # not checkmate if any pieces of same color have valid moves
      @grid.each do |row|
        row.each do |piece|
          return false if piece.color == color &&
            !piece.valid_moves(self).empty?
        end
      end

      return true
    end

    false
  end

  def move(start, end_pos)
    self[start].move!(self, end_pos)
    ensure_promotion(self[end_pos]) if self[end_pos].is_a?(Pawn)
  end

  def dup
    # deep-duplicate the grid, also duplicating each piece
    grid_copy = []
    @grid.each do |row|
      grid_copy_row = []
      row.each do |piece|
        grid_copy_row << piece.dup
      end
      grid_copy << grid_copy_row
    end

    # return a new Board, passing in the grid that we just created
    Board.new(grid_copy)
  end

  def populate
    [0, 7].each do |row|
      row == 0 ? clr = CONSTANTS[:white] : clr = CONSTANTS[:black]
      if clr == CONSTANTS[:white]
        k_col, q_col = 4, 3
      else
        k_col, q_col = 3, 4
      end

      self[[row, 0]] =   Rook.new([row, 0], clr)
      self[[row, 7]] =   Rook.new([row, 7], clr)
      self[[row, 1]] = Knight.new([row, 1], clr)
      self[[row, 6]] = Knight.new([row, 6], clr)
      self[[row, 2]] = Bishop.new([row, 2], clr)
      self[[row, 5]] = Bishop.new([row, 5], clr)
      self[[row, q_col]] =  Queen.new([row, q_col], clr)
      self[[row, k_col]] =   King.new([row, k_col], clr)
    end

    (0..7).each do |el|
      self[[1, el]] = Pawn.new([1, el], CONSTANTS[:white])
      self[[6, el]] = Pawn.new([6, el], CONSTANTS[:black])
    end
  end

  private

  def find_king(color)
    @grid.each do |row|
      row.each do |piece|
        return piece if piece.is_a?(King) && piece.color == color
      end
    end
    nil
  end

  def ensure_promotion(pawn)
    if (pawn.color == CONSTANTS[:white] && pawn.pos[0] == 7) ||
       (pawn.color == CONSTANTS[:black] && pawn.pos[0] == 0)
      @grid[pawn.pos[0]][pawn.pos[1]] = Queen.new(pawn.pos, pawn.color)
    end
  end
end
