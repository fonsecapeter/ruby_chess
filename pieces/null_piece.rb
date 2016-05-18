require 'singleton'

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
