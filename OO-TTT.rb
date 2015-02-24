

class Board
  
  attr_accessor :positions
  
  def initialize
    @positions = {}
    (1..9).each{|position| @positions[position] = ' '}
  end
  
  def draw_board
    puts "Drawing the board"
    system "clear"
    puts " #{positions[1]} | #{positions[2]} | #{positions[3]} "
    puts "---+---+---"
    puts " #{positions[4]} | #{positions[5]} | #{positions[6]} "
    puts "---+---+---"
    puts " #{positions[7]} | #{positions[8]} | #{positions[9]} "
  end
  
  def empty_positions
    positions.select {|k,v| v == ' '}.keys
  end

  def mark(choice, marker)
    positions[choice] = marker
  end

  def delete_position(choice)
    positions.select {|k,v| v !=  ' '}.delete(choice)
  end

end

class Player
  
  attr_accessor :name, :type, :marker
  
  def initialize(marker)
    puts "What is the player's name?"
    @name = gets.chomp
    begin
      puts "Is this a human player or computer?  Please enter 'human' or 'computer'"
      answer = gets.chomp
    end while (answer != 'human') and (answer != 'computer')
    @type = answer
    @marker = marker
  end
    
end

class Game

  attr_accessor :current_player, :choice
      
  def initialize
    @board = Board.new
    puts "Please enter an 'X' player:"
    @x_player = Player.new("X")
    puts ""
    puts "Please enter an 'O' player:"
    @o_player = Player.new("O")
    @current_player = @x_player
  end

  def mark_board_position(board)
    
    if @current_player.type == 'human'
      begin
        puts "#{@current_player.name}, choose an empty square to mark.  Enter '1' for top left, '5' for center, '8' for bottom middle, etc."
        @choice = gets.chomp.to_i
      end until board.empty_positions.include?(@choice)
    else
      @choice = board.empty_positions.sample
      puts "#{@current_player.name} chooses the square at position #{@choice}."
    end
  
    board.mark(@choice, @current_player.marker)
    board.delete_position(@current_player.marker)
    
  end
  
  def check_winner(board)
    winning_lines = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]
    winning_lines.each do |line|
      return @x_player.name if board.positions.values_at(*line).count('X') == 3
      return @o_player.name if board.positions.values_at(*line).count('O') == 3
    end
    nil
  end
  
  

  def play

    def alternate_player
      if @current_player == @x_player
        @current_player = @o_player
      else
        @current_player = @x_player
      end
    end 
    
    
    @board.draw_board
    
    
    begin
      mark_board_position(@board) #player_picks_square(board)
      @board.delete_position(@choice)
      @board.draw_board
      winner = check_winner(@board)
      self.alternate_player

    end until winner || @board.empty_positions.empty?

    if winner
      puts "#{winner} is the winner!"
    else
      puts "It's a tie!"
    end
  end
  
end

@game = Game.new.play
@game