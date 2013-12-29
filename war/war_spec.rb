require 'rubygems'
require 'rspec'
require './war'

describe Card do
  describe "<=>" do
    it "should consider Ace higher than all other cards" do
      ace = Card.new(:hearts, 1)
      (2..14).each do |n|
        other = Card.new(:hearts, n)
        (ace <=> other).should == 1
      end
    end

    it "should consider Aces equal" do
      (Card.new(:hearts, 1) <=> Card.new(:spades, 1)).should == 0
    end
  end

  describe "to_s" do
    it "should name 1 an Ace" do
      Card.new(:spades, 1).to_s.should match("Ace")
    end

    it "should name 11 a Jack" do
      Card.new(:spades, 11).to_s.should match("Jack")
    end

    it "should name 12 a Queen" do
      Card.new(:spades, 12).to_s.should match("Queen")
    end

    it "should name 13 a King" do
      Card.new(:spades, 13).to_s.should match("King")
    end

    it "should capitalize suit names" do
      Card.new(:diamonds, 1).to_s.should match("Diamonds")
      Card.new(:clubs, 1).to_s.should match("Clubs")
      Card.new(:hearts, 1).to_s.should match("Hearts")
      Card.new(:spades, 1).to_s.should match("Spades")
    end
  end
end

describe Deck do
  describe "shuffle" do
    it "should move the cards around" do
      deck = Deck.new
      deck.shuffle
    end
  end

  describe "deal" do
    it "should create two equal sized hands of 21 cards" do
      deck = Deck.new
      hand1, hand2 = deck.deal

      hand1.should have(26).cards
      hand2.should have(26).cards
    end
  end
end

describe Game do
  class QuietListener
    def announce(listener); end
    def increment; end
    def decrement; end
  end

  describe "play_hand" do
    it "should end with a net of 52 cards" do
      game = Game.new(QuietListener.new)
      game.play_hand

      (game.hand1.size + game.hand2.size).should == 52
    end
  end
end
