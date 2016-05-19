class King < SteppingPiece
  def initialize(pos, color)
    super
    @type = :king
    @move_dirs = [:king_move]
  end
end
