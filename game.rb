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


    start_pos, end_pos = nil, nil

    until start_pos &&
      @board[start_pos].color == @current_player &&
      @board[start_pos].valid_moves.length >= 1

      @display.render
      start_pos = @display.cursor.get_input
    end

    until end_pos && @board[start_pos].valid_moves.include?(end_pos)
      @display.render
      end_pos = @display.cursor.get_input
    end

    if start_pos != end_pos
      @board.move_piece(start_pos, end_pos)
      @board[end_pos].pos = end_pos
      switch_player
    end
  end

  def play_game
    while true
      if @board.checkmate?(:white) || @board.checkmate?(:black)
        system('clear')
        break
      end
      play_turn
    end
  end
end

game = Game.new
game.play_game
