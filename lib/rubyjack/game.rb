# frozen_string_literal: true

module Rubyjack
  class Game
    MIN_BET = 5
    MAX_BET = 1000

    def initialize(player_balance: 1000, create_lobby: nil, print: ->(text) { puts text }, read: -> { gets })
      @player_balance = player_balance
      @create_lobby = create_lobby || create_default_lobby
      @print = print
      @read = read
      @bet = 0
    end

    def create_default_lobby
      proc do
        Lobby.new(
          choose_player_action: ->(actions) { ask_turn(actions) },
          print: ->(*args) { print_cards(*args) }
        )
      end
    end

    def start
      start_game do |action|
        if action == :ask_bet
          @bet = ask_bet
          @player_balance -= @bet
          next
        end
        update_balance(action)
        print_result(action)
        # validate balance
        # wait for deal
      end
    end

    def start_game
      loop do
        @lobby = @create_lobby.call
        yield :ask_bet
        yield @lobby.start
      end
    end

    def update_balance(result)
      case result
      when :push_by_blackjack, :push_by_points
        @player_balance += @bet
      when :player_has_blackjack
        @player_balance += @bet + @bet * 3 / 2
      when :dealer_busted, :player_has_more
        @player_balance += @bet * 2
      # when :dealer_has_blackjack, :player_busted, :dealer_has_more
      else
        return
      end
      @bet = 0
    end

    def print_result(result)
      case result
      when :push_by_blackjack, :push_by_points
        @print.call('Push')
      when :player_has_blackjack, :dealer_busted, :player_has_more
        @print.call('You won')
      when :dealer_has_blackjack, :player_busted, :dealer_has_more
        @print.call('Dealer won')
      end
    end

    def ask_bet
      input = nil
      # TODO: make validation better
      until valid_bet?(input)
        @print.call <<~INFO
          Make bet. Minimum: #{MIN_BET}, maximum: #{MAX_BET}
          Available balance: #{@player_balance}
        INFO
        input = @read.call
      end
      input.to_i
    end

    def ask_turn(posible_actions)
      input = nil
      # TODO: make validation better
      until valid_turn?(input, posible_actions)
        @print.call("Possible actions: #{posible_actions.map(&:to_s).join(', ')}")
        input = @read.call.strip
      end
      input.to_sym
    end

    def valid_bet?(input)
      return false if (input =~ /^\d+$/).nil?
      return false unless (MIN_BET..MAX_BET).cover?(input.to_i)

      input.to_i <= @player_balance
    end

    def valid_turn?(input, variants)
      variants.any? { |variant| variant.to_s == input }
    end

    def print_cards(player:, dealer:)
      @print.call <<~INFO
        Dealer hand: #{inspect_hand(dealer.hand)}; sum: #{dealer.hand.sum}
        Player hand: #{inspect_hand(player.hand)}; sum: #{player.hand.sum}
        Bet: #{@bet}
      INFO
    end

    def inspect_hand(hand)
      hand.cards.map do |card|
        if card.opened
          "(#{card.suit}, #{card.type})"
        else
          '(#, #)'
        end
      end.join(', ')
    end
  end
end
