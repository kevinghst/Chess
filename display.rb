require 'colorize'
require_relative 'cursor'
require_relative 'board'


class Display

  attr_accessor :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], @board)
  end

  def render
    system('clear')
    padding = 1

    puts "\n"
    puts letter_row(padding)
    (padding-1).times { puts "\n" }

    8.times do |row_i|
      puts board_row(row_i, padding)
      (padding-1).times { puts "\n" }
    end

    puts letter_row(padding)
    puts "\n"

  end

  def letter_row(padding=1)
    row = "  "
    ('a'..'h').each do |column|
      row += " " * padding + column
    end

    row + " " * (padding + 2)
  end

  def board_row(row_i, padding=1)
    row = " " + (8 - row_i).to_s
    8.times do |col_i|
      piece = @board[[row_i, col_i]]
      piece_repr = piece.symbol

      if cursor.cursor_pos == [row_i, col_i]
        piece_repr = piece_repr.colorize(:color => :white, :background => :black)
      end

      row += " " * padding + (piece_repr)
    end

    row + " " * padding + (8 - row_i).to_s + " "
  end
end

if __FILE__ == $PROGRAM_NAME
  _pry_.config.print = proc {}
  b = Board.new
  d = Display.new(b)
  d.render
  p b[[0,3]].valid_moves
end
