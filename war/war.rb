#!/usr/bin/env ruby

require 'delegate'

Card = Struct.new(:suit, :number) do
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

  def collect(cards)
    push(*cards)
  end

  def to_s
    sort.each { |card| puts card.to_s }
  end
end

class Deck
  def initialize
    @cards = []

    [:hearts, :spades, :diamonds, :clubs].each do |suit|
      (1..13).each do |number|
        @cards << Card.new(suit, number)
      end
    end
  end

  def shuffle
    @cards.shuffle!
  end

  def deal
    return Hand.new(@cards[0...26]), Hand.new(@cards[26..-1])
  end
end


class Game
  def initialize
    deck = Deck.new
    deck.shuffle

    @hand1, @hand2 = deck.deal
  end

  def run
    loop do
      if @hand1.empty?
        puts
        puts "Player 2 Wins!"
        break
      elsif @hand2.empty?
        puts
        puts "Player 1 Wins!"
        break
      end

      play_match
    end
  end

  def play_match(indent = " ", pile = [])
    card1 = @hand1.draw
    card2 = @hand2.draw

    pile.push(card1, card2).compact!

    indent = " " * (pile.size / 2)

    print indent
    if card1.nil?
      puts "Player 1 is out of cards"
    else
      puts "Player 1: #{card1.to_s}"
    end

    print indent
    if card2.nil?
      puts "Player 2 is out of cards"
    else
      puts "Player 2: #{card2.to_s}"
    end

    if card1.nil?
      @hand2.collect(pile)
    elsif card2.nil?
      @hand1.collect(pile)
    else
      case card1 <=> card2
      when 1
        print indent
        puts "Player 1 wins match"
        @hand1.collect(pile)
      when -1
        print indent
        puts "Player 2 wins match"
        @hand2.collect(pile)
      when 0
        play_tie(indent, pile)
      end
    end
  end

  def play_tie(indent, pile)
    print indent
    puts "Draw: Each player draws two cards"

    2.times do
      pile << @hand1.draw
      pile << @hand2.draw
    end

    play_match(indent, pile)
  end
end

if __FILE__ == $0
  Game.new.run
end
