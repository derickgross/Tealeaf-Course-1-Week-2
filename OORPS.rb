# OORPS.rb - object oriented Rock Paper Scissors game.

=begin
1.   Model objects: Weapon (rock, paper, or scissors), Player
=end

class Player
  attr_accessor :weapon
  attr_reader :name
  
  def initialize(n)
    @name = n
  end
  
  def to_s
    "#{name} chose to wage war with #{self.weapon.type}!"
  end
  
end

class HumanPlayer < Player
  
  def choose_weapon
    puts "Please choose a weapon!  Choose rock, paper or scissors:"
    t = gets.chomp
    while !War::WEAPONS.include?(t)
      if t == "rocket launcher"
        puts "Rocket launcher?  That would be cheating, Solid Snake.  Please choose rock, paper or scissors:"
        t = gets.chomp
      else
        puts "You can't wage a Rock Paper Scissors battle with #{t}.  Please choose rock, paper or scissors:"
        t = gets.chomp
      end
     end
     self.weapon = Weapon.new(t)
  end
end

class ComputerPlayer < Player
  attr_reader :name
  
  def initialize(n)
    @name = n
  end
  
  def choose_weapon
    self.weapon = Weapon.new(War::WEAPONS.sample)
  end
end

class Weapon
  
  include Comparable
  
  attr_reader :type
  
  def initialize(t)
    
    @type = t
  end
  
  def <=>(other_weapon)
    if @type == other_weapon.type
      0
    elsif (@type == "rock" && other_weapon.type == "scissors") || (@type == "paper" && other_weapon.type == "rock") || (@type == "scissors" && other_weapon.type == "paper")
      1
    else
      -1
    end
  end
     
end

class War
  WEAPONS = ["rock", "paper", "scissors"]
  
  attr_reader :player, :computer
  
  def initialize
    puts "You've chosen to wage Rock Paper Scissors war with JOSHUA, the fourth savviest computer ever."
    puts "What is your name, valiant Rock Paper Scissors warrior?"
    @player = HumanPlayer.new(gets.chomp)
    puts ""
    @computer = ComputerPlayer.new("JOSHUA")
  end
  
  def compare_weapons
    if player.weapon == computer.weapon
      puts "It's a tie!"
    elsif player.weapon > computer.weapon
      puts "#{player.name} wins!  JOSHUA owes you a cookie."
    else
      puts "#{computer.name} wins, and is destined to take over the world."
    end
  end
    
    def battle
      player.choose_weapon
      computer.choose_weapon
      puts ""
      puts player
      puts computer
      compare_weapons # also declares winner
    end
end

game = War.new.battle