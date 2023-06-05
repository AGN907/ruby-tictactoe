class Player
  attr_accessor :name, :sign

  @@signs = %w[X O]
  @@players = []

  def initialize(name)
    @name = name
    @sign = @@signs.pop
    greet_player
    @@players << self
  end

  def self.players
    @@players
  end

  private

  def greet_player
    puts "Hello #{name}!"
    puts "Your sign is #{sign}"
  end
end

class Game
  attr_accessor :player1, :player2, :board, :current_turn, :win_patterens

  def self.init_players
    puts('Hello to a game of TicTacToe!')

    puts 'Choose the first player name: '
    p1_name = gets.chomp
    player1 = Player.new(p1_name)

    puts 'Choose the second player name: '
    p2_name = gets.chomp
    player2 = Player.new(p2_name)

    [player1, player2]
  end

  def initialize(players)
    @player1 = players[0]
    @player2 = players[1]
    @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @current_turn = player1
    @is_finished = false
  end

  def start_game
    draw_board
    pick_square until @is_finished
  end

  private

  def pick_square
    puts("#{current_turn.name} Please choose one of the squares from 1-9")
    is_there = false
    until is_there
      number = gets.chomp.to_i
      is_there = board.include?(number) ? !is_there : is_there
      puts('Already choosen! Please choose another square') unless is_there
    end

    change_board(number)
    finished?
    change_turn
  end

  def build_patterens
    {
      first: @board[0..2],
      second: @board[3..5],
      third: @board[6..8],
      fourth: [@board[0], @board[3], @board[6]],
      fifth: [@board[1], @board[4], @board[7]],
      sixth: [@board[2], @board[5], @board[8]],
      seventh: [@board[0], @board[4], @board[8]],
      eighth: [@board[2], @board[4], @board[6]]
    }
  end

  def check_patterens(array)
    @win_patterens = build_patterens
    @win_patterens.each do |_key, data|
        @is_finished = true if data == array
    end
  end

  def draw_board
    new_board = ''
    @board.each_with_index do |item, idx|
      new_board +=
        if ((idx + 1) % 3).zero?
          "#{item}\n "

        else
          "#{item} | "
        end
    end

    puts("\n #{new_board}")
  end

  def change_board(number)
    index = board.index(number)
    board[index] = current_turn.sign

    draw_board
  end

  def change_turn
    @current_turn = @current_turn == player1 ? player2 : player1
  end

  def finished?
    regex = Regexp.new("#{player1.sign}|#{player2.sign}")
    if @board.all?(regex)
      puts "It's a draw!"
      @is_finished = true

    else
      sign_array = Array.new(3, current_turn.sign)
      check_patterens(sign_array)
      puts "#{current_turn.name}, congratulations for winning!" if @is_finished
    end
  end
end

Game.init_players

game = Game.new(Player.players)

game.start_game
