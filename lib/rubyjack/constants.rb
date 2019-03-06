# frozen_string_literal: true

module Rubyjack
  module Constants
    CARDS_SUITS = [:clubs, :diamonds, :hearts, :spades].freeze
    FACE_CARDS = [:jack, :queen, :king].freeze
    ACE = :ace
    NUMBERED_CARDS = (2..10).freeze
  end
end
