# frozen_string_literal: true

require 'rubyjack/hand'

module Rubyjack
  class Dealer
    attr_accessor :hand

    def initialize(hand: Hand.new)
      @hand = hand
    end

    def turn(shoe)
      @hand.add_card(shoe.hit!) while @hand.sum < 17
    end

    def open_hand!
      @hand.cards.each(&:open!)
    end
  end
end
