# frozen_string_literal: true

require 'rubyjack/base_player'

module Rubyjack
  class Dealer < BasePlayer
    attr_accessor :hand

    def initialize(name: 'Dealer')
      @name = name
      @hand = []
    end

    def move
    end
  end
end
