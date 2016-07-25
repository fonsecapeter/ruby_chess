require 'colorize'
require_relative 'modules/cursorable'
require_relative 'constants'

class Display
  include Cursorable
  attr_accessor :selected
  attr_reader :board

  def initialize(board, player_color, player_1, player_2)
    @board = board
    @cursor_pos = player_color == CONSTANTS[:player_1_color] ? [1, 0] : [6, 7]
    @player_color = player_color
    @selected = nil
    @player_1 = player_1
    @player_2 = player_2
  end

  def render
    system("clear")
    # 9.times { print "\x1B[1A\x1B[2K" } <= very noticable alt to clear
    draw_board.each { |row| puts row.join }
  end

  private

  attr_accessor :cursor_pos
  
  def draw_board
    if @selected
      @available_spaces = @board[@selected].valid_moves(@board)
      @unavailable_spaces = @board[@selected].moves(@board) - @available_spaces
    else
      @available_spaces = []
      @unavailable_spaces = []
    end

    output = [[@player_1.captured_to_s]]
    @board.grid.each_with_index do |row, i|
      output_row = []
      row.each_with_index do |space, j|
        output_row << space.to_s.colorize(colors_for(i, j))
      end
      output << output_row
    end
    output << [@player_2.captured_to_s]
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = @player_color
    elsif @available_spaces.include?([i, j])
      bg = :dark_white
    elsif @unavailable_spaces.include?([i, j])
      bg = :magenta
    elsif (i + j).even?
      bg = CONSTANTS[:board_color_light]
    else
      bg = CONSTANTS[:board_color_dark]
    end


    if [i, j] == @selected
      clr = @player_color.to_s[0..5] == "light_" ? @player_color[6..-1] : "light_#{@player_color}".to_sym
    elsif @board[[i, j]].type == :king && @board.checkmate?(@board[[i, j]].color)
      clr = :magenta
    else
      clr = @board[[i, j]].color
    end
    { background: bg, color: clr }
  end
end
