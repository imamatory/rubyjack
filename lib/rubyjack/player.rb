# frozen_string_literal: true

module Rubyjack
  class Player
    attr_accessor :hand

    def initialize(name: 'John Doe', account: 0, hand: Hand.new)
      @name = name
      @account = account
      @hand = hand
    end
  end
end
