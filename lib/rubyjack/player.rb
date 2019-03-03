# frozen_string_literal: true

require 'rubyjack/base_player'

module Rubyjack
  class Player < BasePlayer
    def initialize(name: 'John Doe', account: 0, hands: [Hand.new])
      @name = name
      @account = account
      @hands = hands
    end
  end
end
