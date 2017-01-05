module SteppingPiece
  def self.included klass
    klass.singleton_class.send(:attr_reader, :move_diffs)
  end

  def legal_moves
    legal_moves = []

    self.class.move_diffs.each do |move_diff|
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
