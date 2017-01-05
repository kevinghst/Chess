require_relative 'pieces'
require_relative 'stepping_piece'

class King < Piece
  def symbol
    @color == :black ? '♚' : '♔'
  end
  include SteppingPiece
end
