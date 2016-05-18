require_relative 'board'
require_relative 'player'

class Game
  def initialize
    @board = Board.new
    @board.build_board
    @player_1 = Player.new(@board, :red, :white)
    @player_2 = Player.new(@board, :green, :black)
    @current_player = @player_2
    @display_1 = Display.new(@board, @player_1.color)
    @display_2 = Display.new(@board, @player_2.color)
    @current_display = @display_2
  end

  def play
    until @board.checkmate?(:white) || @board.checkmate?(:black)
      play_turn
    end
    @current_display.render
    puts "Game Over!!!!!!"
  end

  def play_turn
    switch_players
    @current_display.render
    starting_pos, target_pos = @current_player.get_move(@board)

    @board.move(starting_pos, target_pos)
  end

  def switch_players
    if @current_player == @player_1
      @current_player = @player_2
      @current_display = @display_2
    else
      @current_player = @player_1
      @current_display = @display_1
    end
  end
end

g = Game.new
g.play
