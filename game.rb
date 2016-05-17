require_relative 'board'
require_relative 'player'

class Game
  def initialize
    @board = Board.new
    @player = Player.new(@board)
  end

  def play
  end

  def play_turn
    starting_pos = @player.get_pos
  end
end

g = Game.new
g.play_turn
