require_relative 'display'
require_relative 'constants'

class Player
  attr_reader :color, :captured_pieces
  attr_writer :display
  def initialize(board, color, team, display = {})
    @board = board
    # @display = Display.new(board, color)
    @display = display
    @color = color
    @team = team
    @captured_pieces = []
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
        raise TargetPosError unless board[starting_pos].valid_moves(board).include?(target_pos)
      rescue TargetPosError
        retry
      end

    rescue ResetPosError
      starting_pos = nil
      target_pos = nil
      @display.selected = nil
      retry
    end

    unless @board[target_pos].is_a?(NullPiece)
      @captured_pieces << @board[target_pos].to_s
    end

    @display.selected = nil
    [starting_pos, target_pos]
  end

  def captured_to_s
    captured_string = ""
    (0...24).each do |idx|
      captured_string += idx < captured_pieces.length ? captured_pieces[idx].strip : " "
    end
    captured_string.colorize(background: @color, color: opposing_team)
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

  def opposing_team
    return @team == CONSTANTS[:white] ? CONSTANTS[:black] : CONSTANTS[:white]
  end
end

class StartingPosError < StandardError
end

class TargetPosError < StandardError
end

class ResetPosError < StandardError
end
