class SteppingPiece < Piece
  def moves(board)
    possible_moves = []

    if @move_dirs.include?(:king_move)
      [-1,0,1].each do |i|
        [-1,0,1].each do |j|
          possible_moves << [@pos[0] + i, @pos[1] + j]
        end
      end
    end

    if @move_dirs.include?(:knight_move)
      [-1,1].each do |one|
        [-2,2].each do |two|
          possible_moves << [@pos[0] + one, @pos[1] + two]
          possible_moves << [@pos[0] + two, @pos[1] + one]
        end
      end
    end
    in_bound_moves = possible_moves.select { |move| board.in_bounds?(move) }
    in_bound_moves.select { |move| board[move].color != @color }
   end
end
