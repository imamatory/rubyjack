module Rubyjack
  class Deck
    def initialize(_cards = nil)
      @cards ||= build_deck
    end

    def build_deck
      Constants::CARDS_SUITS.reduce([]) do |acc, suit|
        acc.concat(Constants::NUMBER_CARDS.map { |type| Card.new(suit: suit, type: type) })
           .concat(Constants::FACE_CARDS.map { |type| Card.new(suit: suit, type: type) })
           .concat(Constants::ACE)
      end
    end

    def shuffle!; end
  end
end
