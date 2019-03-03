# frozen_string_literal: true

module Rubyjack
  class Game
    def initialize(shoe: Shoe.new, player: Player.new)
      @shoe = shoe
      @player = player
    end
  end
end
