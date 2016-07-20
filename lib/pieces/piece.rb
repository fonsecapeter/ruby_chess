class Piece
  TYPES = {
    null:   "   ",
    king:   " \u265A ".encode('utf-8'),
    queen:  " \u265B ".encode('utf-8'),
    bishop: " \u265D ".encode('utf-8'),
    knight: " \u265E ".encode('utf-8'),
    rook:   " \u265C ".encode('utf-8'),
    pawn:   " \u265F ".encode('utf-8')
  }

  attr_reader :color, :pos, :type

  def initialize(pos, color)
    @pos = pos
    @color = color
  end

  def to_s
    TYPES[@type]
  end

  def moves(_board)
    # give all possible moves that are:
    #   a.) on the board
    #   b.) not blocked by onto another piece
    #   => further defined in sublasses
    []
  end

  def valid_moves(board)
    # takes all of my moves and only gives back those that do not
    # put my color in check
    valid_moves = []
    moves(board).each do |pos|
      board_copy = board.dup
      move(board_copy, pos)

      valid_moves << pos unless board_copy.in_check?(@color)
    end
    valid_moves
  end

  def move(board, new_pos)
    starting_pos = @pos
    board[new_pos] = self
    board[starting_pos] = NullPiece.instance
  end

  def move!(board, new_pos)
    move(board, new_pos)
    @pos = new_pos
  end
end
