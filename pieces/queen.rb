class Queen < SlidingPiece
  def initialize(pos, color)
    super
    @type = :queen
    @move_dirs = [:diagonal, :horizontal_vertical]
  end
end
