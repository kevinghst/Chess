require_relative 'pieces/pieces'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/null'
require_relative 'pieces/pawn'


class Board

  attr_accessor :grid

  def initialize
    @null_piece = NullPiece.instance
    @grid = Array.new(8) { Array.new(8) { @null_piece } }
    populate_back_rows
    populate_pawn_rows
  end

  def populate_pawn_rows
    [:black, :white].each do |color|
      row_i = color == :black ? 1 : 6
      (0..7).each do |col_i|
        self[[row_i, col_i]] = Pawn.new(self, [row_i, col_i], color)
      end
    end
  end

  def populate_back_rows
    [:black, :white].each do |color|
      row_i = color == :black ? 0 : 7
      self[[row_i, 0]] = Rook.new(self, [row_i, 0], color)
      self[[row_i, 7]] = Rook.new(self, [row_i, 7], color)

      self[[row_i, 1]] = Knight.new(self, [row_i, 1], color)
      self[[row_i, 6]] = Knight.new(self, [row_i, 6], color)

      self[[row_i, 2]] = Bishop.new(self, [row_i, 2], color)
      self[[row_i, 5]] = Bishop.new(self, [row_i, 5], color)

      if row_i == 0
        self[[row_i, 4]] = King.new(self, [row_i, 4], :black)
        self[[row_i, 3]] = Queen.new(self, [row_i, 3], :black)
      else
        self[[row_i, 4]] = King.new(self, [row_i, 4], :white)
        self[[row_i, 3]] = Queen.new(self, [row_i, 3], :white)
      end
    end
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def fillrow(row_i)
    @grid[row_i].each_index do |col_i|
      self[[row_i, col_i]] = Piece.new
    end
  end

  def move_piece(start_pos, end_pos)
      self[end_pos] = self[start_pos]
      self[start_pos] = @null_piece
  end

  def inbounds?(pos)
    pos.all? {|pos_i| (0..7).include?(pos_i)}
  end

  def has_piece?(pos)
    self[pos] != @null_piece
  end

  def in_check?(color)
    symbol = color == :black ? '♚' : '♔'
    position = search_board(symbol)
    vulnerable(position)
  end

  def search_board(target_symbol)
    (0..7).each do |row|
      (0..7).each do |col|
        if @grid[row][col].symbol == target_symbol
          return [row, col]
        end
      end
    end
  end

  def vulnerable(position)
    target_color = self[position].color
    oppos_color = target_color == :white ? :black : :white
    (0..7).each do |row|
      (0..7).each do |col|
        if @grid[row][col].color == oppos_color && @grid[row][col].legal_moves.include?(position)
          return true
        end
      end
    end
    false
  end

  def checkmate?(color)
    condition = false
    if self.in_check?(color)
      condition = true
      (0..7).each do |row|
        (0..7).each do |col|
          if @grid[row][col].color == color && (@grid[row][col].valid_moves != [])
            condition = false
          end
        end
      end
    end
    condition
  end

  def dup
    dup_grid = deep_dup(@grid)
    dup_board = Board.new
    dup_board.grid = dup_grid
    return dup_board
  end

  def deep_dup(array)
     new_array = []
     array.each do |el|
       if el.is_a?(Array)
         new_array << deep_dup(el)
       elsif el.class == NullPiece
         new_array << el
       else
         new_array << el.dup
       end
     end
     new_array
   end
end
