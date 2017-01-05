require_relative 'pieces'
require_relative 'stepping_piece'

class Knight < Piece
  def symbol
    @color == :black ? '♞' : '♘'
  end
  include SteppingPiece
end
