class WelcomeController < ApplicationController
  

  def index
    size = 10
    unless params[:board]
      @board = []
      (0..size).each { |e|
        row = []
        (0..size).each{ |e|
          row.append 0
        }
        @board.append row
      }      
      @board = new_piece(@board)
      @board = new_piece(@board)
    else
      @board = JSON.parse(params[:board])
    end

    dir = params[:dir];
    if dir
      case dir
        when 'a'
          result, @board = move_left(@board)
        when 'd'
          result, @board = move_right(@board)
        when 's'
          result, @board = move_down(@board)
        when 'w'
          result, @board = move_up(@board)
      end
      @board = new_piece(@board) if result
      result, @board = check_lose(@board)
      if result
        @message=':-( maybe next time'
      end
      if check_win(@board)
        @message='*<:-) WINNER!'
      end
    end
  end

end
