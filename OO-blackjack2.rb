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
    card_name
  end
end

module Hand
 
  def add_card(new_card)
    @hand_cards << new_card
    calculate_hand_value
  end
  
  def new_card
    "#{name} was dealt #{hand_cards.last}."
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
    "#{name} shows #{hand_cards.first}.  The second card remains unseen."
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
    suit.each do |suit|
      rank.each do |rank|
        @cards << Card.new(suit, rank)
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
  attr_accessor :deck, :human_player, :dealer, :answer, :count, :player_name
  
  @player_name = nil
  
  def initialize
    @deck = Deck.new
    @human_player = Player.new("Derick")
    @dealer = Dealer.new
    @answer = nil
  end

  def play
    deal_hands
    show_initial_hands
    dealt_blackjack

    if human_player.calculate_hand_value != 21
      puts "What would you like to do?  1. hit  2. stay"
      hit_or_stay = gets.chomp
      while !['1', '2'].include?(hit_or_stay)
        puts "What would you like to do?  1. hit  2. stay"
        hit_or_stay = gets.chomp
      end
      if hit_or_stay == '2'
        puts "You chose to stay with a hand value of #{human_player.calculate_hand_value}."
        add_blank_line
      else
        player_turn
      end
    end
    dealer_turn    
    play_again
  end    


  def add_blank_line
    puts " "
  end

  def play_again
    puts "Would you like to play again?  1. yes  2. no"
    again = gets.chomp
    while !['1', '2'].include?(again)
      puts "Would you like to play again?  1. yes  2. no"
      again = gets.chomp
    end
    if again == '1'
      add_blank_line
      Game.new.play
    else
      add_blank_line
      puts "Thank you for playing!  Hope you had fun."
    end
  end
  
  def deal_hands
    human_player.add_card(deck.deal_one)
    human_player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)    
  end
  
  def show_initial_hands
    puts human_player
    puts dealer
  end
  
  def dealt_blackjack
    if human_player.calculate_hand_value == 21
      puts "Blackjack!  You win!"
      answer = nil
    end    
  end
  
  def player_turn
    hit_or_stay = nil
    add_blank_line
    human_player.add_card(deck.deal_one)
    puts human_player.new_card
    if human_player.calculate_hand_value > 21
      puts "#{human_player.name}, your hand value is now #{human_player.calculate_hand_value}.  You bust!"
      #answer = nil
    elsif human_player.calculate_hand_value == 21
      puts "Blackjack!  You win!"
      #answer = nil
    else
      puts "Your hand value is now #{human_player.calculate_hand_value}.  What would you like to do?  1. hit  2. stay"
      hit_or_stay = gets.chomp
      while !['1', '2'].include?(hit_or_stay)
        puts "You must choose either hit or stay. The hand value is #{human_player.calculate_hand_value}.  What would you like to do?  1. hit  2. stay"
        hit_or_stay = gets.chomp
      end
      if hit_or_stay == '2'
        puts "You chose to stay with a hand value of #{human_player.calculate_hand_value}."
        add_blank_line      
      else
        player_turn
      end
    end
  end
    
  def dealer_turn
    while dealer.calculate_hand_value < human_player.calculate_hand_value
      puts "Dealer hits."
      dealer.add_card(deck.deal_one)
      puts dealer.new_card
      add_blank_line
    end
    if dealer.calculate_hand_value == 21
      puts "Blackjack- dealer wins."
    elsif dealer.calculate_hand_value > 21
      puts "Dealer busts- you win!"
    elsif dealer.calculate_hand_value == human_player.calculate_hand_value
      puts "House rules- dealer's hand value of #{dealer.calculate_hand_value} beats #{human_player.name}'s hand value of #{human_player.calculate_hand_value}.  Dealer wins."
    else
      puts "Dealer's hand value of #{dealer.calculate_hand_value} beats #{human_player.name}'s hand value of #{human_player.calculate_hand_value}.  Dealer wins."
    end   
  end
end

Game.new.play