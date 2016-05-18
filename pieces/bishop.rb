class Bishop < SlidingPiece
  def initialize(pos, color)
    super
    @type = :bishop
    @move_dirs = [:diagonal]
  end
end
