module SteppingPiece

  KING_DIFFS = [
    [-1,-1],
    [-1, 0],
    [-1, 1],
    [0, 1],
    [1, 1],
    [1, 0],
    [1, -1],
    [0, -1]
  ]

  KNIGHT_DIFFS = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
  ]

  def legal_moves
    legal_moves = []

    move_diffs = nil

    case self
    when Knight
      move_diffs = KNIGHT_DIFFS
    when King
      move_diffs = KING_DIFFS
    end

    move_diffs.each do |move_diff|
      x = @pos[0] + move_diff[0]
      y = @pos[1] + move_diff[1]

      if @board.inbounds?([x, y]) && @board[[x, y]].color != @color
        legal_moves << [x, y]
      end
    end
    return legal_moves
  end

  def valid_moves
    valid_moves = self.legal_moves
    new_moves = valid_moves.select {|move| self.move_into_check?(move) == false}
    return new_moves
  end

end
