require 'colorize'
require_relative 'cursor'
require_relative 'board'
require_relative 'display'
require_relative 'pieces/pieces'
require 'byebug'

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
        start_pos, end_pos = nil, nil
        until start_pos
          @display.render
          start_pos = @display.cursor.get_input
        end
        until end_pos
          @display.render
          end_pos = @display.cursor.get_input
        end

        if start_pos == end_pos
          raise "Can't move to same location"
        elsif @board[start_pos].color != @current_player
          raise "You have to move your own piece"
        elsif !@board[start_pos].valid_moves.include?(end_pos)
          raise "Invalid Move"
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
        puts "White Wins"
        break
      else
        play_turn
      end
    end
  end
end

game = Game.new
game.play_game
