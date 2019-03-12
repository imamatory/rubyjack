# frozen_string_literal: true

require 'rubyjack/card'
require 'rubyjack/constants'

module Rubyjack
  class Shoe
    def initialize(cards: nil, amount_of_decks: 6)
      @cards = cards || build_shoe(amount_of_decks)
    end

    def hit!(opened: true)
      card = @cards.pop
      card.opened = opened
      card
    end

    def cards_left
      @cards.length
    end

    def shuffle!
      @cards = @cards.shuffle
      self
    end

    private

    def build_deck
      Constants::CARDS_SUITS.reduce([]) do |acc, suit|
        acc.concat(Constants::NUMBERED_CARDS.map { |type| Card.new(suit: suit, type: type) })
           .concat(Constants::FACE_CARDS.map { |type| Card.new(suit: suit, type: type) })
           .push(Card.new(suit: suit, type: Constants::ACE))
      end
    end

    def build_shoe(amount_of_decks)
      amount_of_decks.times.reduce([]) { |acc| acc.concat(build_deck) }
    end
  end
end
