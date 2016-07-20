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
      begin
        starting_pos = get_pos
        raise StartingPosError if board[starting_pos].is_a?(NullPiece) ||
          # board[starting_pos].valid_moves(board).empty? || # taking this out in lue of being able to unselect
          board[starting_pos].color != @team
      rescue StartingPosError
        retry
      end

      begin
        @display.selected = starting_pos
        target_pos = get_pos
        raise ResetPosError if target_pos == starting_pos # toggle selected
        raise TargetPosError unless board[starting_pos].valid_moves(board).include?(target_pos) || ResetPosError
      rescue TargetPosError
        retry
      end

    rescue ResetPosError
      starting_pos = nil
      target_pos = nil
      @display.selected = nil
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

class ResetPosError < StandardError
end
