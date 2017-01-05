require 'colorize'
require_relative 'cursor'
require_relative 'board'
require_relative 'display'
require_relative 'pieces/pieces'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/null'
require_relative 'pieces/pawn'

class Game

  def initialize()
    @current_player = :white
    @board = Board.new
    @display = Display.new(@board)
  end

  def switch_player
    @current_player = @current_player == :white ? :black : :white
  end

  def play_turn
      begin
        @display.current_player = @current_player.to_s
        start_pos, end_pos = nil, nil
        until start_pos
          @display.render
          start_pos = @display.cursor.get_input
        end
        @display.notifications = {}
        until end_pos
          @display.render
          end_pos = @display.cursor.get_input
        end

        if start_pos == end_pos || !@board[start_pos].valid_moves.include?(end_pos)
          raise "Invalid Move"
        elsif @board[start_pos].color != @current_player
          raise "Not your turn"
        end

        @board.move_piece(start_pos, end_pos)
        @board[end_pos].pos = end_pos
        switch_player
      rescue StandardError => e
        @display.notifications[:error] = e.message
        retry
      end
  end

  def play_game
    while true
      if @board.checkmate?(:white)
        puts "Black wins!"
        break
      elsif @board.checkmate?(:black)
        puts "White wins!"
        break
      else
        play_turn
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play_game
end
