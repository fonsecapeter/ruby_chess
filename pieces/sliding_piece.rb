class SlidingPiece < Piece
  def moves(board)
    possible_moves = []

    if @move_dirs.include?(:diagonal)
      slide(possible_moves, board) { |i| [@pos[0] + i, @pos[1] + i] }
      slide(possible_moves, board) { |i| [@pos[0] + i, @pos[1] - i] }
      slide(possible_moves, board) { |i| [@pos[0] - i, @pos[1] + i] }
      slide(possible_moves, board) { |i| [@pos[0] - i, @pos[1] - i] }
    end

    if @move_dirs.include?(:horizontal_vertical)
      # horizontal
      slide(possible_moves, board) { |i| [@pos[0], @pos[1] + i] }
      slide(possible_moves, board) { |i| [@pos[0], @pos[1] - i] }
      # vert
      slide(possible_moves, board) { |i| [@pos[0] + i, @pos[1]] }
      slide(possible_moves, board) { |i| [@pos[0] - i, @pos[1]] }
    end

    possible_moves
  end

  private
  def slide(possible_moves, board, &prc)
    1.upto(7) do |i|
      possible_pos = prc.call(i)

      if board.in_bounds?(possible_pos)
        possible_moves << possible_pos if board[possible_pos].color != @color
        if board[possible_pos].is_a?(NullPiece) == false
          break
        end
      end

    end
  end
end
