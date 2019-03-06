# frozen_string_literal: true

RSpec.describe(Rubyjack::Lobby) do
  let(:ace) { Rubyjack::Card.new(suit: :spades, type: :ace) }
  let(:ten) { Rubyjack::Card.new(suit: :spades, type: 10) }
  let(:king) { Rubyjack::Card.new(suit: :diamonds, type: :king) }
  let(:queen) { Rubyjack::Card.new(suit: :diamonds, type: :queen) }
  let(:four) { Rubyjack::Card.new(suit: :diamonds, type: 4) }
  let(:eight) { Rubyjack::Card.new(suit: :diamonds, type: 8) }

  describe 'simple push' do
    let(:shoe) { Rubyjack::Shoe.new(cards: [ace, eight, eight, ace]) }
    let(:player_actions) { [:stand] }
    let(:choose_player_action) { ->(_) { player_actions.pop } }

    it do
      expect(described_class.new(shoe: shoe, choose_player_action: choose_player_action).start).to eq(:push_by_points)
    end
  end

  describe 'blackjack push' do
    let(:shoe) { Rubyjack::Shoe.new(cards: [ace, ace, ten, queen]) }
    let(:player_actions) { [:stand] }
    let(:choose_player_action) { ->(_) { player_actions.pop } }

    it do
      expect(described_class.new(shoe: shoe, choose_player_action: choose_player_action).start).to eq(:push_by_blackjack)
    end
  end

  describe 'player won with blackjack' do
    let(:shoe) { Rubyjack::Shoe.new(cards: [four, ace, ten, ten]) }
    let(:player_actions) { [:stand] }
    let(:choose_player_action) { ->(_) { player_actions.pop } }

    it do
      expect(described_class.new(shoe: shoe, choose_player_action: choose_player_action).start).to eq(:player_has_blackjack)
    end
  end

  describe 'dealer won with blackjack' do
    let(:shoe) { Rubyjack::Shoe.new(cards: [ace, four, ten, ten]) }
    let(:player_actions) { [:stand] }
    let(:choose_player_action) { ->(_) { player_actions.pop } }

    it do
      expect(described_class.new(shoe: shoe, choose_player_action: choose_player_action).start).to eq(:dealer_has_blackjack)
    end
  end

  describe 'player busted 1 card' do
    let(:shoe) { Rubyjack::Shoe.new(cards: [queen, ace, four, four, ten]) }
    let(:player_actions) { [:hit] }
    let(:choose_player_action) { ->(_) { player_actions.pop } }

    it do
      expect(described_class.new(shoe: shoe, choose_player_action: choose_player_action).start).to eq(:player_busted)
    end
  end

  describe 'player busted 2 card' do
    let(:shoe) { Rubyjack::Shoe.new(cards: [king, four, king, four, ten, ten]) }
    let(:player_actions) { [:hit, :hit] }
    let(:choose_player_action) { ->(_) { player_actions.pop } }

    it do
      lobby = described_class.new(shoe: shoe, choose_player_action: choose_player_action)
      expect(lobby.start).to eq(:player_busted)
      expect(lobby.player.hand.sum).to eq(28)
    end
  end
end
