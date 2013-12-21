require 'rubygems'
require 'rspec'
require './war'

describe Card do
  it "should consider Ace higher than all other cards" do
    ace = Card.new(:heart, 1)
    (2..14).each do |n|
      other = Card.new(:heart, n)
      (ace <=> other).should == 1
    end
  end

  it "should consider Aces equal" do
    (Card.new(:heart, 1) <=> Card.new(:spade, 1)).should == 0
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
