# frozen_string_literal: true

RSpec.describe(Rubyjack::Game) do
  let(:ace) { Rubyjack::Card.new(suit: :spades, type: :ace) }
  let(:ten) { Rubyjack::Card.new(suit: :spades, type: 10) }
  let(:king) { Rubyjack::Card.new(suit: :diamonds, type: :king) }
  let(:queen) { Rubyjack::Card.new(suit: :diamonds, type: :queen) }
  let(:four) { Rubyjack::Card.new(suit: :diamonds, type: 4) }
  let(:three) { Rubyjack::Card.new(suit: :diamonds, type: 3) }
  let(:eight) { Rubyjack::Card.new(suit: :diamonds, type: 8) }

  describe 'simple push' do
    let(:shoe) { Rubyjack::Shoe.new(cards: [ace, eight, eight, ace]) }
    let(:player_actions) { [:stand] }
    let(:input) { ['100'] }
    let(:read) { -> { input.pop } }
    let(:print) { ->(_) {} }
    let(:create_lobby) do
      proc do
        Rubyjack::Lobby.new(
          shoe: shoe,
          choose_player_action: ->(_) { player_actions.pop }
        )
      end
    end

    it do
      game = described_class.new(player_balance: 1000, create_lobby: create_lobby, print: print, read: read)
      game.start_game { break }
      expect(game.player_balance).to eq(1000)
    end
  end

  describe 'player has blackjack' do
    let(:shoe) { Rubyjack::Shoe.new(cards: [ace, king, eight, ace]) }
    let(:player_actions) { [:stand] }
    let(:input) { ['100'] }
    let(:read) { -> { input.pop } }
    let(:print) { ->(_) {} }
    let(:create_lobby) do
      proc do
        Rubyjack::Lobby.new(
          shoe: shoe,
          choose_player_action: ->(_) { player_actions.pop }
        )
      end
    end

    it do
      game = described_class.new(player_balance: 1000, create_lobby: create_lobby, print: print, read: read)
      game.start_game { break }
      expect(game.player_balance).to eq(1150)
    end
  end

  describe 'player has more' do
    let(:shoe) { Rubyjack::Shoe.new(cards: [ten, eight, eight, ace]) }
    let(:player_actions) { [:stand] }
    let(:input) { ['1000'] }
    let(:read) { -> { input.pop } }
    let(:print) { ->(_) {} }
    let(:create_lobby) do
      proc do
        Rubyjack::Lobby.new(
          shoe: shoe,
          choose_player_action: ->(_) { player_actions.pop }
        )
      end
    end

    it do
      game = described_class.new(player_balance: 1000, create_lobby: create_lobby, print: print, read: read)
      game.start_game { break }
      expect(game.player_balance).to eq(2000)
    end
  end

  describe 'player lose all' do
    let(:shoe) { Rubyjack::Shoe.new(cards: [queen, eight, eight, eight]) }
    let(:player_actions) { [:stand] }
    let(:input) { ['1000'] }
    let(:read) { -> { input.pop } }
    let(:print) { ->(_) {} }
    let(:create_lobby) do
      proc do
        Rubyjack::Lobby.new(
          shoe: shoe,
          choose_player_action: ->(_) { player_actions.pop }
        )
      end
    end

    it do
      game = described_class.new(player_balance: 1000, create_lobby: create_lobby, print: print, read: read)
      game.start_game { break }
      expect(game.player_balance).to eq(0)
    end
  end
end
