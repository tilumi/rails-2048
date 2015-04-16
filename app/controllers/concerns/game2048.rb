module Game2048
  extend ActiveSupport::Concern

  def check_win(board)
    return board.flatten.max == 2048
  end


  def new_piece(board)
    size = board.length-1
    piece = rand(1..2) * 2 # generate either 2 or 4
    xx = rand(0..size)
    yy = rand(0..size)
    (0..size).each { |ii|
      (0..size).each { |jj|
        x1 = (xx + ii) % 4
        y1 = (yy + jj) % 4
        if board[x1][y1] == 0
          board[x1][y1] = piece
          return board
        end
      }
    }
    return false
  end

  def shift_left line
    l2 = Array.new
    line.each { |ii|
      if not ii == 0
        l2.push ii
      end
    }
    while not l2.size == line.size
      l2.push 0
    end
    return l2
  end

  def move_left(board)
    tempBoard = Marshal.load(Marshal.dump(board))
    size = board.length-1
    (0..size).each { |ii|
      (0..size).each { |jj|
        (jj..size-1).each { |kk|
          if board[ii][kk + 1] == 0
            next
          elsif board[ii][jj] == board[ii][kk + 1]
            board[ii][jj] = board[ii][jj] * 2
            board[ii][kk + 1] = 0
          end
          break
        }
      }
      board[ii] = shift_left board[ii]
    }
    if board == tempBoard
      return false, board
    else
      return true, board
    end
  end

  def move_right(board)
    board.each { |a| a.reverse! }
    result, board = move_left(board)
    board.each { |a| a.reverse! }
    return result, board
  end

  def move_down(board)
    board = board.transpose.map &:reverse
    result, board = move_left(board)
    board = board.transpose.map &:reverse
    board = board.transpose.map &:reverse
    board = board.transpose.map &:reverse
    return result, board
  end

  def move_up(board)
    board = board.transpose.map &:reverse
    board = board.transpose.map &:reverse
    board = board.transpose.map &:reverse
    result, board = move_left(board)
    board = board.transpose.map &:reverse
    return result, board
  end

  def check_lose(board)
    tempBoard = Marshal.load(Marshal.dump(board))
    t = move_right(board)
    if t == false
      t = move_left(board)
      if t == false
        t = move_up(board)
        if t == false
          t = move_down(board)
          if t == false
            board = Marshal.load(Marshal.dump(tempBoard))
            return true, board
          end
        end
      end
    end
    board = Marshal.load(Marshal.dump(tempBoard))
    return false, board
  end

end

