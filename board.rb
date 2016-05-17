require_relative 'pieces'

class Board
  attr_reader :grid
  def initialize(grid = Array.new(8) {Array.new(8) {NullPiece.new} })
    @grid = grid
    build_board
  end

  def move(start, end_pos)
    begin
      raise "No starting piece" if self[start].is_a?(NullPiece)
      raise "Invalid end point" if invalid?(end_pos)
    rescue
      retry
    end

    self[start].move_to(end_pos)
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

  private
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
      self[[6, el]] = Pawn.new([1,el], :black)
    end

  end
end
