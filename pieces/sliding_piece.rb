module SlidingPiece

  ROOK_DIFFS = [
    [-1, 0],
    [0, 1],
    [1, 0],
    [0, -1]
  ]

  BISHOP_DIFFS = [
    [-1, -1],
    [-1, 1],
    [1, 1],
    [1, -1]
  ]

  QUEEN_DIFFS = [
    [-1,-1],
    [-1, 0],
    [-1, 1],
    [0, 1],
    [1, 1],
    [1, 0],
    [1, -1],
    [0, -1]
  ]

  def valid_moves
    valid_moves = self.legal_moves
    new_moves = valid_moves.select {|move| self.move_into_check?(move) == false}
    return new_moves
  end

  def legal_moves
    valid_moves = []

    move_diffs = nil

    case self
    when Rook
      move_diffs = ROOK_DIFFS
    when Bishop
      move_diffs = BISHOP_DIFFS
    when Queen
      move_diffs = QUEEN_DIFFS
    end
    move_diffs.each do |move_diff|
      x = @pos[0]
      y = @pos[1]
      while true
        x += move_diff[0]
        y += move_diff[1]
        if @board.inbounds?([x, y]) && @board[[x, y]].color != @color
          valid_moves << [x, y]
          break if @board[[x, y]].color
        else
          break
        end
      end
    end
    valid_moves
  end
end
