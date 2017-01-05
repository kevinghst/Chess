require_relative 'pieces'
require_relative 'sliding_piece'

class Bishop < Piece
  include SlidingPiece

  attr_reader :move_diffs

  def symbol
    @color == :black ? '♝' : '♗'
  end

  @move_diffs = [
    [-1, -1],
    [-1, 1],
    [1, 1],
    [1, -1]
  ]

end
