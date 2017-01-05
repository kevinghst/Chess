require 'singleton'
require_relative 'stepping_piece'
require_relative 'sliding_piece'

class Piece
  attr_accessor :color, :pos, :board, :type

  def initialize(board, pos, color)
    @type = nil
    @board = board
    @pos = pos
    @color = color
  end

  def oppo_color
    @color == :black ? :white : :black
  end

  def symbol
    @type
  end

  def move_into_check?(end_pos)
    start_pos = @pos.dup
    dup_board = @board.dup

    (0..7).each do |row|
      (0..7).each do |col|
        dup_board.grid[row][col].board = dup_board
      end
    end

    dup_board.move_piece(start_pos, end_pos)
    return true if dup_board.in_check?(@color)
    false
  end
end
