# frozen_string_literal: true

# require 'blackjack/dealer'

module Rubyjack
  class Lobby
    attr_reader :player, :dealer

    def initialize(shoe: nil, player: Player.new, choose_player_action: nil, print: nil)
      @shoe = shoe || Shoe.new.shuffle!
      @player = player
      @dealer = Dealer.new
      @choose_player_action = choose_player_action
      @print = print || ->(player:, dealer:) {}
    end

    def start
      start_lobby do |status|
        early_result = check_early_result
        @dealer.open_hand! if !early_result.nil? || status == :check_result
        @print.call(player: @player, dealer: @dealer)

        return early_result unless early_result.nil?
        return check_result if status == :check_result
      end
    end

    def start_lobby
      hit_initial
      yield :first_distribution

      loop do
        choise = choose_player_action
        break if choise != :hit

        @player.hand.add_card(@shoe.hit!)
        yield
      end

      @dealer.turn(@shoe)

      yield :check_result
    end

    private

    def hit_initial
      @player.hand.add_card(@shoe.hit!)
      @dealer.hand.add_card(@shoe.hit!)
      @player.hand.add_card(@shoe.hit!)
      @dealer.hand.add_card(@shoe.hit!(opened: false))
    end

    def player_actions
      [:stand, :hit]
    end

    def choose_player_action
      @choose_player_action.call(player_actions)
    end

    def check_early_result
      return :push_by_blackjack if @player.hand.blackjack? && @dealer.hand.blackjack?
      return :player_has_blackjack if @player.hand.blackjack?
      return :dealer_has_blackjack if @dealer.hand.blackjack?
      return :dealer_busted if @dealer.hand.busted?
      return :player_busted if @player.hand.busted?
    end

    def check_result
      return :player_has_more if @player.hand.sum > @dealer.hand.sum
      return :dealer_has_more if @player.hand.sum < @dealer.hand.sum

      :push_by_points
    end
  end
end
