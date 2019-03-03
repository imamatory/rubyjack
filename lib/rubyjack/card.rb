# frozen_string_literal: true

module Rubyjack
  class Card
    attr_reader :suit, :type

    def initialize(suit:, type:)
      @suit = suit
      @type = type
    end

    def ==(other)
      (type == other.type) && (suit == other.suit)
    end

    def ace?
      @type == Constants::ACE
    end
  end
end
