#!/usr/bin/env ruby
require 'rubygems'
require 'bundler'
require_relative 'lib/board'
require_relative 'lib/player'
require_relative 'lib/computer_player'
require_relative 'lib/constants'

class Game
  def initialize(num_players = 1)
    @board = Board.new
    @board.populate

    if num_players < 1
      @player_1 = ComputerPlayer.new(@board, CONSTANTS[:player_1_color], CONSTANTS[:white])
    else
      @player_1 = Player.new(@board, CONSTANTS[:player_1_color], CONSTANTS[:white])
    end

    if num_players < 2
      @player_2 = ComputerPlayer.new(@board, CONSTANTS[:player_2_color], CONSTANTS[:black])
    else
      @player_2 = Player.new(@board, CONSTANTS[:player_2_color], CONSTANTS[:black])
    end

    @current_player = @player_2
    @display_1 = Display.new(@board, @player_1.color, @player_1, @player_2)
    @display_2 = Display.new(@board, @player_2.color, @player_1, @player_2)
    @current_display = @display_2

    @player_1.display = @display_1
    @player_2.display = @display_2
  end

  def play
    play_turn until @board.checkmate?(CONSTANTS[:white]) || @board.checkmate?(CONSTANTS[:black])

    @current_display.render
    puts '     Game Over!!!!!'
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

if __FILE__ == $0
  num_players = ARGV[0] || 1
  g = Game.new(num_players.to_i)
  g.play
end
