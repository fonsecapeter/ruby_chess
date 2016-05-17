require_relative 'display'

class Player
  def initialize(board)
    @display = Display.new(board)
  end

  def get_move(board)
    begin
      starting_pos = get_pos
      raise "No starting piece" if board[starting_pos].is_a?(NullPiece)
    rescue
      retry
    end
    puts "#{starting_pos} selected"
    begin
      target_pos = get_pos
      raise "Invalid end point" unless board[starting_pos].valid_moves.include?(target_pos)
    rescue
      retry
    end
    puts "#{starting_pos} > #{target_pos}"
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
