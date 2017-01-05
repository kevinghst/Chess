require 'singleton'
require_relative 'pieces'

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
