require_relative 'pieces'
require_relative 'null'

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
