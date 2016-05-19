class Knight < SteppingPiece
  def initialize(pos, color)
    super
    @type = :knight
    @move_dirs = [:knight_move]
  end
end
