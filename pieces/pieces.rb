require 'singleton'
require 'byebug'
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

class King < Piece
  def symbol
    @color == :black ? '♚' : '♔'
  end
  include SteppingPiece
end

class Knight < Piece
  def symbol
    @color == :black ? '♞' : '♘'
  end
  include SteppingPiece
end

class Rook < Piece
  def symbol
    @color == :black ? '♜' : '♖'
  end
  include SlidingPiece
end

class Bishop < Piece
  def symbol
    @color == :black ? '♝' : '♗'
  end
  include SlidingPiece
end

class Queen < Piece
  def symbol
    @color == :black ? '♛' : '♕'
  end
  include SlidingPiece
end


class NullPiece < Piece
  include Singleton
  def initialize
    @type = :null_piece
    @color = nil
  end

  def symbol
    " "
  end
end

class Pawn < Piece
  FORWARD_DIFFS = {
    black: [1, 0],
    white: [-1, 0]
  }

  ATTACK_DIFFS = {
    black: [[1,-1], [1,1]],
    white: [[-1,-1],[-1,1]]
  }

  def symbol
    @color == :black ? '♟' : '♙'
  end

  def valid_moves
    valid_moves = self.legal_moves
    new_moves = valid_moves.select {|move| self.move_into_check?(move) == false}
    return new_moves
  end

  def legal_moves
    valid_moves = []
    one_forward = pawn_forward_pos
    valid_moves += pawn_attack_pos
    valid_moves << one_forward if one_forward
    if on_pawn_row? && one_forward
      two_forward = pawn_forward_pos(2)
      valid_moves << two_forward if two_forward
    end
    valid_moves
  end

  def pawn_forward_pos(spots = 1)
    x = @pos[0] + FORWARD_DIFFS[@color][0] * spots
    y = @pos[1] + FORWARD_DIFFS[@color][1] * spots
    forward = [x, y]
    return forward if @board[forward].is_a? NullPiece
    nil
  end

  def on_pawn_row?
    if @pos[0] == 1 && @color == :black
      return true
    elsif @pos[0] == 6 && @color == :white
      return true
    end
    false
  end

  def pawn_attack_pos
    ATTACK_DIFFS[@color].map {|x, y| [@pos[0] + x, @pos[1] + y] }.select do |a_pos|
      @board.inbounds?(a_pos) && @board[a_pos].color == oppo_color
    end
  end
end
