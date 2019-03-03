# frozen_string_literal: true

module Rubyjack
  class Card
    attr_reader :suit, :type

    def initialize(suit:, type:)
      @suit = suit
      @type = type
    end

    def value
      11 if @type == Constants::ACE
      10 if Constants::FACE_CARDS.include? @type
      @type
    end

    def ==(other)
      (type == other.type) && (suit == other.suit)
    end
  end
end
