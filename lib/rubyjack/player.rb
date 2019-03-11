# frozen_string_literal: true

module Rubyjack
  class Player
    attr_accessor :hand

    def initialize(account: 0, hand: Hand.new)
      @account = account
      @hand = hand
    end
  end
end
