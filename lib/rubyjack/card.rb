# frozen_string_literal: true

module Rubyjack
  class Card
    attr_reader :suit, :title

    def initialize(suit:, type:)
      @suit = suit
      @type = type
    end

    def value
      11 if @type == Constants::ACE
      10 if Constants::FACE_CARDS.include? @type
      @type
    end
  end
end
