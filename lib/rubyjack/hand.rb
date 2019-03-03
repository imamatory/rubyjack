module Rubyjack
  class Hand
    def initialize(bet: Bet.new, cards: [])
      @bet = bet
      @cards = cards
    end
  end
end
