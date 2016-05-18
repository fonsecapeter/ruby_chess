require_relative 'pieces_manifest'

class Board
  attr_reader :grid
  def initialize(grid = Array.new(8) {Array.new(8) {NullPiece.instance} })
    @grid = grid
  end

  def move(start, end_pos)
    self[start].move!(self, end_pos)
  end

  def in_bounds?(pos)
    pos.all? { |coordinate| coordinate.between?(0, 7) }
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end

  def in_check?(color)
    our_king = nil
    @grid.each do |row|
      row.each do |space|
        our_king = space if space.is_a?(King) && space.color == color
      end
    end

    @grid.each do |row|
      row.each do |space|
        unless space.color == color && space.is_a?(NullPiece)
          return true if space.moves(self).include?(our_king.pos)
        end
      end
    end

    false
  end

  def dup
    # deep-duplicate the grid, also duplicating each piece
    grid_copy = []
    @grid.each do |row|
      grid_copy_row = []
      row.each do |space|
        grid_copy_row << space.dup
      end
      grid_copy << grid_copy_row
    end

    # return a new Board, passing in the grid that we just created
    Board.new(grid_copy)
  end

  def checkmate?(color)
    if self.in_check?(color)
      @grid.each do |row|
        row.each do |space|
          if space.color == color && !space.valid_moves(self).empty?
            return false
          end
        end
      end
      return true
    end
    return false
  end

  def build_board
    self[[0, 0]] = Rook.new([0,0], :white)
    self[[0, 7]] = Rook.new([0,7], :white)
    self[[7, 0]] = Rook.new([7,0], :black)
    self[[7, 7]] = Rook.new([7,7], :black)
    self[[0, 1]] = Knight.new([0,1], :white)
    self[[0, 6]] = Knight.new([0,6], :white)
    self[[7, 1]] = Knight.new([7,1], :black)
    self[[7, 6]] = Knight.new([7,6], :black)
    self[[0, 2]] = Bishop.new([0,2], :white)
    self[[0, 5]] = Bishop.new([0,5], :white)
    self[[7, 2]] = Bishop.new([7,2], :black)
    self[[7, 5]] = Bishop.new([7,5], :black)
    self[[0, 3]] = Queen.new([0,3], :white)
    self[[0, 4]] = King.new([0,4], :white)
    self[[7, 3]] = Queen.new([7,3], :black)
    self[[7, 4]] = King.new([7,4], :black)

    (0..7).each do |el|
      self[[1, el]] = Pawn.new([1,el], :white)
      self[[6, el]] = Pawn.new([6,el], :black)
    end

  end
end
