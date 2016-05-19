require_relative 'display'

class Player
  attr_reader :color
  def initialize(board, color, team)
    @display = Display.new(board, color)
    @color = color
    @team = team
  end

  def get_move(board)

    begin
      starting_pos = get_pos
      raise StartingPosError if board[starting_pos].is_a?(NullPiece) ||
        board[starting_pos].valid_moves(board).empty? ||
        board[starting_pos].color != @team
    rescue StartingPosError
      retry
    end

    begin
      @display.selected = starting_pos
      target_pos = get_pos
      raise TargetPosError unless board[starting_pos].valid_moves(board).include?(target_pos)
    rescue TargetPosError
      retry
    end

    @display.selected = nil
    [starting_pos, target_pos]
  end

  private
  def get_pos
    result = nil
    until result
      @display.render
      result = @display.get_input
    end
    result
  end
end

class StartingPosError < StandardError
end

class TargetPosError < StandardError
end
