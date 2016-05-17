require_relative 'display'

class Player
  def initialize(board)
    @display = Display.new(board)
  end

  def get_pos
    result = nil
    until result
      @display.render
      result = @display.get_input
    end
    result
  end
end
