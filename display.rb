require 'colorize'
require_relative 'cursor'
require_relative 'board'
require 'byebug'

class Display

  attr_accessor :cursor, :notifications, :current_player

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], @board)
    @notifications = {}
    @current_player
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

    puts "    #{@current_player}'s turn".colorize(:color => :blue)
    puts "\n"

    @notifications.each do |key, val|
      puts "#{val}".colorize(:color => :red)
    end

  end

  def letter_row(padding=1)
    row = "  "
    ('a'..'h').each do |column|
      row << " " * padding + column.colorize(:color => :light_black)
    end
    row + " " * (padding + 2)
  end

  def board_row(row_i, padding=1)
    row = " " + (8 - row_i).to_s.colorize(:color => :light_black)
    8.times do |col_i|
      piece = @board[[row_i, col_i]]
      piece_repr = piece.symbol

      if cursor.cursor_pos == [row_i, col_i]
        row << (" ".colorize(:background => :black) + (piece_repr.colorize(:color => :white, :background => :black)))
      else
        if row_i % 2 == 0
          if col_i % 2 == 0
            row << (" " + (piece_repr))
          else
            row << (" ".colorize(:background => :light_black) + (piece_repr.colorize(:background => :light_black)))
          end
        else
          if col_i % 2 == 0
            row << (" ".colorize(:background => :light_black) + (piece_repr.colorize(:background => :light_black)))
          else
            row << (" " + (piece_repr))
          end
        end
      end
    end
    row + " " + (8 - row_i).to_s.colorize(:color => :light_black) + " "
  end
end
