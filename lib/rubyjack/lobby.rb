# frozen_string_literal: true

# require 'blackjack/dealer'

module Rubyjack
  class Lobby
    attr_reader :player

    def initialize(shoe: Shoe.new, player: Player.new, choose_player_action: ->(_x) { :stand }, print: -> {})
      @shoe = shoe
      @player = player
      @dealer = Dealer.new
      @choose_player_action = choose_player_action
      @print = print
    end

    def start
      start_lobby do |status|
        @print.call
        return :push_by_blackjack if @player.hand.blackjack? && @dealer.hand.blackjack?
        return :player_has_blackjack if @player.hand.blackjack?
        return :dealer_has_blackjack if @dealer.hand.blackjack?
        return :dealer_busted if @dealer.hand.busted?
        return :player_busted if @player.hand.busted?

        return check_result if status == :check_result
      end
    end

    def start_lobby
      hit_initial
      yield :first_distribution

      choise = choose_player_action
      while choise == :hit
        @player.hand.add_card(@shoe.hit!)
        yield
        choise = choose_player_action
      end

      @dealer.turn(@shoe)

      yield :check_result
    end

    private

    def hit_initial
      2.times do
        @player.hand.add_card(@shoe.hit!)
        @dealer.hand.add_card(@shoe.hit!)
      end
    end

    def player_actions
      [:stand, :hit]
    end

    def choose_player_action
      @choose_player_action.call(player_actions)
    end

    def check_result
      return :player_has_more if @player.hand.sum > @dealer.hand.sum
      return :dealer_has_more if @player.hand.sum < @dealer.hand.sum

      :push_by_points
    end
  end
end
