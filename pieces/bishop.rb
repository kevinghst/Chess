require_relative 'pieces'
require_relative 'sliding_piece'

class Bishop < Piece
  def symbol
    @color == :black ? '♝' : '♗'
  end
  include SlidingPiece


end
