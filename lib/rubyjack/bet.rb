# frozen_string_literal: true

module Rubyjack
  class Bet
    attr_reader :amount

    def initialize(amount = 0)
      @amount = amount
    end

    def double
      @amount *= 2
    end
  end
end
