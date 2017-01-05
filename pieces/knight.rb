require_relative 'pieces'
require_relative 'stepping_piece'

class Knight < Piece
  include SteppingPiece

  def symbol
    @color == :black ? '♞' : '♘'
  end

  @move_diffs = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
  ]
end
