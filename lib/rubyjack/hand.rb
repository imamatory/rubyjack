# frozen_string_literal: true

module Rubyjack
  class Hand
    attr_accessor :cards

    def initialize(cards = [])
      @cards = cards
    end

    def sum
      count = count_without_aces
      aces = @cards.select(&:ace?)
      case aces.length
      when 0
        count
      when 1
        if count < 11
          count + 11
        else
          count + 1
        end
      when 2
        if count < 10
          count + 11 + 1
        else
          count + 2
        end
      end
    end

    def length
      @cards.length
    end

    def empty?
      @cards.empty?
    end

    def add_card(card)
      @cards.push(card)
    end

    def blackjack?
      sum == 21 && @cards.length == 2
    end

    def busted?
      sum > 21
    end

    def ==(other)
      @cards.zip(other.cards).all? { |pair| pair.first == pair.last }
    end

    private

    def count_without_aces
      @cards.reduce(0) do |acc, card|
        if card.type == Constants::ACE
          acc + 0
        elsif Constants::FACE_CARDS.include?(card.type)
          acc + 10
        else
          acc + card.type
        end
      end
    end
  end
end
