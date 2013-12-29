#!/usr/bin/env ruby

require 'delegate'

# A Card from a deck of playing cards.
Card = Struct.new(:suit, :number) do
  # Pretty print a card.
  #
  # @return [String]
  def to_s
    number_name =
      case number
      when 1 then "ace"
      when 11 then "jack"
      when 12 then "queen"
      when 13 then "king"
      else
        number.to_s
      end

    "#{number_name.capitalize} of #{suit.to_s.capitalize}"
  end

  # Compare two cards.
  #
  # @return [Integer]
  def <=>(other)
    if number == 1 && other.number == 1
      0
    elsif number == 1
      1
    else
      self.number <=> other.number
    end
  end
end

class Hand < DelegateClass(Array)
  alias draw shift

  # The action of taking a pile of cards and putting it back on your own.
  # Shuffling the cards before adding them back to the hand prevents "endless
  # war."
  #
  # http://www.rajgiri.net/index.php
  #
  # @param [Array<Card>] cards
  # @return [Array<Card>]
  def collect(cards)
    push(*(cards.shuffle))
  end

  # Pretty-print a hand.
  #
  # @return [String]
  def to_s
    sort.map(&:to_s).join("\n")
  end
end

# A standard deck of cards.
class Deck
  # List of suits in a deck of cards.
  SUITS = [:diamonds, :clubs, :hearts, :spades]

  # Create a new standard deck of cards.
  def initialize
    @cards = []

    SUITS.each do |suit|
      (1..13).each do |number|
        @cards << Card.new(suit, number)
      end
    end
  end

  # Shuffle (randomize) the cards in a Deck.
  #
  # @return [Deck]
  def shuffle
    @cards.shuffle!

    self
  end

  # Split the deck into two halves.
  #
  # @return [Hand, Hand]
  def deal
    return Hand.new(@cards[0...26]), Hand.new(@cards[26..-1])
  end
end

class Listener
  def initialize
    @indent = 0
  end

  def announce(string)
    print ' ' * @indent
    puts string
  end

  def increment
    @indent += 1
  end 
  def decrement
    @indent -= 1
  end
end

# A representation for an actual War card game played between two players.
class Game
  attr_reader :listener, :hand1, :hand2

  # Creates a new game.
  def initialize(listener)
    @listener      = listener
    @hand1, @hand2 = Deck.new.shuffle.deal
  end

  # Play War.
  def play
    loop do
      if @hand1.empty?
        listener.announce "Player 2 Wins!"
        break
      elsif @hand2.empty?
        listener.announce "Player 1 Wins!"
        break
      end

      play_hand
    end
  end

  # Play a hand in War.
  def play_hand(pile = [])
    card1 = @hand1.draw
    card2 = @hand2.draw

    pile.push(card1, card2).compact!

    listener.increment

    if card1.nil?
      listener.announce "Player 1 is out of cards"
    else
      listener.announce "Player 1: #{card1.to_s}"
    end

    if card2.nil?
      listener.announce "Player 2 is out of cards"
    else
      listener.announce "Player 2: #{card2.to_s}"
    end

    if card1.nil?
      @hand2.collect(pile)
    elsif card2.nil?
      @hand1.collect(pile)
    else
      case card1 <=> card2
      when 1
        listener.announce "Player 1 wins hand"
        @hand1.collect(pile)
      when -1
        listener.announce "Player 2 wins hand"
        @hand2.collect(pile)
      when 0
        play_tie(pile)
      end
    end

    listener.decrement
  end

  # Play out a tie between players.
  #
  # @param [Array<Cards>] pile Current stack of cards on the table
  def play_tie(pile)
    listener.announce "Draw: Each player draws three cards"

    3.times do
      pile << @hand1.draw
      pile << @hand2.draw
    end

    play_hand(pile)
  end
end

if __FILE__ == $0
  Game.new(Listener.new).play
end
