require 'colorize'
require_relative 'modules/cursorable'

class Display
  include Cursorable
  attr_accessor :selected
  attr_reader :board

  def initialize(board, player_color)
    @board = board
    @cursor_pos = [0, 0]
    @player_color = player_color
    @selected = nil
  end

  def render
    system("clear")
    # 9.times { print "\x1B[1A\x1B[2K" } <= very noticable
    draw_board.each { |row| puts row.join }
  end

  private
  def draw_board
    output = []
    @board.grid.each_with_index do |row, i|
      output_row = []
      row.each_with_index do |space, j|
        output_row << space.to_s.colorize(colors_for(i, j))
      end
      output << output_row
    end
    output
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = @player_color
    elsif (i + j).even?
      bg = :blue
    else
      bg = :light_black
    end

    if [i, j] == @selected
      clr = :blue
    else
      clr = @board[[i, j]].color
    end
    { background: bg, color:clr }
  end
end
