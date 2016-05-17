require 'colorize'
require_relative 'cursorable'

class Display
  include Cursorable
  attr_reader :board

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
    @selected = nil
  end

  def render
    system("clear")
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
      bg = :light_green
    elsif (i + j).even?
      bg = :light_blue
    else
      bg = :light_black
    end
    { background: bg, color: @board[[i, j]].color }
  end
end
