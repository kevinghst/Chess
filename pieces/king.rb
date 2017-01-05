require_relative 'pieces'
require_relative 'stepping_piece'

class King < Piece
  include SteppingPiece

  def symbol
    @color == :black ? '♚' : '♔'
  end

  @move_diffs = [
    [-1,-1],
    [-1, 0],
    [-1, 1],
    [0, 1],
    [1, 1],
    [1, 0],
    [1, -1],
    [0, -1]
  ]
end
