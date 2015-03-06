# OO-blackjack.rb
require 'pry'

class Card
  attr_accessor :suit, :rank, :card_name
  
  def initialize(suit, rank)
    @suit = suit                # ['Spades', 'Hearts', 'Diamonds', 'Clubs']
    @rank = rank                # ['2','3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    @card_name = "#{rank} of #{suit}"
  end 
  
  def to_s
    name
  end
end

module Hand
 
  def add_card(new_card)
    @hand_cards << new_card
    calculate_hand_value
  end
  
  def new_card
    "#{name} was dealt #{hand_cards.map(&:card_name).last}."
  end  
  
  def calculate_hand_value
    self.hand_value = 0
    hand_cards.each do |card|
      case card.rank
        when '2'
        self.hand_value += 2
        when '3'
        self.hand_value += 3
        when '4'
        self.hand_value += 4
        when '5'
        self.hand_value += 5
        when '6'
        self.hand_value += 6
        when '7'
        self.hand_value += 7
        when '8'
        self.hand_value += 8
        when '9'
        self.hand_value += 9
        when '10'
        self.hand_value += 10
        when 'J'
        self.hand_value += 10
        when 'Q'
        self.hand_value += 10
        when 'K'
        self.hand_value += 10
        when 'A'
          if self.hand_value <= 10
            self.hand_value += 11
          else
            self.hand_value += 1
          end
      end
    end 
    return self.hand_value
  end

  def is_busted?
    hand_value > 21
  end
end

class Player
  attr_accessor :name, :hand_cards, :hand_value
  
  def to_s
    "#{name}'s hand is #{hand_cards.map(&:card_name).join(", ")} and has a value of #{hand_value}."
  end  
  
  include Hand
  
  def initialize(name)
    @name = name
    @hand_cards = []
    @hand_value = 0
  end
end

class Dealer
  attr_accessor :name, :hand_cards, :hand_value  

  def to_s
    "#{name} shows #{hand_cards.map(&:card_name).first}.  The second card remains unseen."
  end
  
  def reveal_dealer_hand
    
  end

  include Hand
  
  def initialize
    @name = "Dealer"
    @hand_cards = []
    @hand_value = 0    
  end
end

class Deck
  attr_accessor :deck, :cards
  def initialize
    suit = ['Spades', 'Hearts', 'Diamonds', 'Clubs']
    rank = ['2','3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    @cards = []
    suit.each do |s|
      rank.each do |r|
        @cards << Card.new(s, r)
      end
    end
    shuffle
  end
  
  def shuffle
    cards.shuffle!
  end
  
  def deal_one
    cards.pop
  end
end

class Game
  attr_accessor :game_over
  def initialize
    @game_over = false
  end
  
  def play_again?
    puts "Would you like to play again?  1. yes  2. no"
    answer = gets.chomp
    while answer != '1' and answer != '2'
      puts "Would you like to play again?  1. yes  2. no"
      answer = gets.chomp
    end
    if answer == '1'
      puts " "
      Game.new.play
    else
      puts " "
      puts "Thank you for playing!  Hope you had fun."
    end
  end
 
  def play
    deck = Deck.new
    human_player = Player.new('Derick')
    dealer = Dealer.new
    human_player.add_card(deck.deal_one)
    human_player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    puts human_player
    puts dealer
    
    if human_player.calculate_hand_value == 21
      puts "Blackjack!  You win!"
      answer = "0"
      play_again?
    end
    
    puts "What would you like to do?  1. hit  2. stay"
    answer = gets.chomp
    while answer != '1' and answer != '2'
      puts "What would you like to do?  1. hit  2. stay"
      answer = gets.chomp
    end


    while answer == "1"
      puts " "
      human_player.add_card(deck.deal_one)
      puts human_player.new_card
      if human_player.calculate_hand_value > 21
        puts "#{human_player.name}, your hand value is now #{human_player.calculate_hand_value}.  You bust!"
        answer = "0"
        play_again?
      elsif human_player.calculate_hand_value == 21
        puts "Blackjack!  You win!"
        answer = "0"
        play_again?
      else
        puts "Your hand value is now #{human_player.calculate_hand_value}.  What would you like to do?  1. hit  2. stay"
        answer = gets.chomp
      end

      if human_player.calculate_hand_value < 21
        while dealer.calculate_hand_value < human_player.calculate_hand_value
          puts "Dealer hits."
          dealer.add_card(deck.deal_one)
          puts dealer.new_card
          puts " "
        end
        if dealer.calculate_hand_value == 21
          puts "Blackjack- dealer wins."
          play_again?
        elsif dealer.calculate_hand_value > 21
          puts "Dealer busts- you win!"
          play_again?
        elsif dealer.calculate_hand_value == human_player.calculate_hand_value
          puts "House rules- dealer's hand value of #{dealer.calculate_hand_value} beats #{human_player.name}'s hand value of #{human_player.calculate_hand_value}.  Dealer wins."
          play_again?
        else
          puts "Dealer's hand value of #{dealer.calculate_hand_value} beats #{human_player.name}'s hand value of #{human_player.calculate_hand_value}.  Dealer wins."
          play_again?
        end
      end
    end
  end
end

Game.new.play