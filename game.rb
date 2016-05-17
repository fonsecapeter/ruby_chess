require_relative 'board'
require_relative 'player'

class Game
  def initialize
    @board = Board.new
    @board.build_board
    @player = Player.new(@board)
    @display = Display.new(@board)
  end

  def play
  end

  def play_turn
    @display.render
    starting_pos, target_pos = @player.get_move(@board)

    @board.move(starting_pos, target_pos)

  end
end

g = Game.new
g.play_turn
