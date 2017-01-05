require 'byebug'
module SlidingPiece

  def self.included klass
    klass.singleton_class.send(:attr_reader, :move_diffs)
  end

  def valid_moves
    valid_moves = self.legal_moves
    new_moves = valid_moves.select {|move| self.move_into_check?(move) == false}
    return new_moves
  end

  def legal_moves
    valid_moves = []
    
    self.class.move_diffs.each do |move_diff|
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
