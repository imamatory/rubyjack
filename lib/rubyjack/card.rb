# frozen_string_literal: true

module Rubyjack
  class Card
    attr_reader :suit, :type
    attr_accessor :opened

    def initialize(suit:, type:, opened: true)
      @suit = suit
      @type = type
      @opened = opened
    end

    def ==(other)
      (type == other.type) && (suit == other.suit)
    end

    def ace?
      @type == Constants::ACE
    end

    def open!
      @opened = true
    end
  end
end
