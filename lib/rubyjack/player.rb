module Rubyjack
  class Player
    def initialize(name: 'John Doe', account: 0, hands: [Hand.new])
      @name = name
      @account = account
      @hands = hands
    end
  end
end
