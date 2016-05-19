class Rook < SlidingPiece
  def initialize(pos, color)
    super
    @type = :rook
    @move_dirs = [:horizontal_vertical]
  end
end
