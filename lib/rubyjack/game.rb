# frozen_string_literal: true

module Rubyjack
  class Game
    MIN_BET = 5
    MAX_BET = 1000

    attr_reader :player_balance

    def initialize(player_balance: 1000, create_lobby: nil, print: nil, read: nil)
      @player_balance = player_balance
      @create_lobby = create_lobby || create_default_lobby
      @print = print || ->(text) { puts text }
      @read = read || -> { gets }
      @bet = 0
    end

    def start
      print_greeting
      loop do
        start_game do
          refill_balance_if_needed
        end
      end
    end

    def start_game
      @lobby = @create_lobby.call

      @bet = ask_bet
      @player_balance -= @bet

      result = @lobby.start

      update_balance(result)
      print_result(result)
      yield
    end

    def create_default_lobby
      proc do
        Lobby.new(
          choose_player_action: ->(actions) { ask_turn(actions) },
          print: ->(*args) { print_cards(*args) }
        )
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

    def refill_balance_if_needed
      return if @player_balance.positive?

      @player_balance = 1000
      @print.call('Casino has refilled your balance. Cheers!')
    end

    def print_greeting
      @print.call <<~INFO
        Welcome to Rubyjack blackjack!
        Press Ctrl-C to exit\n
      INFO
    end

    def print_result(result)
      reason = result.to_s.tr('_', ' ')
      @print.call("\n" + '#' * 20 + "\n")
      case result
      when :push_by_blackjack, :push_by_points
        @print.call("Push (#{reason})")
      when :player_has_blackjack, :dealer_busted, :player_has_more
        @print.call("You won (#{reason})")
      when :dealer_has_blackjack, :player_busted, :dealer_has_more
        @print.call("Dealer won (#{reason})")
      end
      @print.call('#' * 20 + "\n\n")
    end

    def ask_bet
      input = nil
      until valid_bet?(input)
        @print.call <<~INFO
          Make bet. Minimum: #{MIN_BET}, maximum: #{MAX_BET}
          Available balance: #{@player_balance}
        INFO
        input = @read.call.strip
      end
      input.to_i
    end

    def ask_turn(posible_actions)
      input = nil
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
      has_closed_cards = dealer.hand.cards.any? { |card| !card.opened }
      masked_sum = has_closed_cards ? '*' : dealer.hand.sum
      @print.call <<~INFO
        Dealer hand: #{inspect_hand(dealer.hand)}; sum: #{masked_sum}
        Player hand: #{inspect_hand(player.hand)}; sum: #{player.hand.sum}
        Bet: #{@bet}
      INFO
    end

    def inspect_hand(hand)
      hand.cards.map do |card|
        if card.opened
          "(#{card.type} of #{card.suit})"
        else
          '(#, #)'
        end
      end.join(', ')
    end
  end
end
