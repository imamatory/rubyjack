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
    let(:choose_player_action) { ->(_) { player_actions.pop } }

    it do
      expect(described_class.new(shoe: shoe, choose_player_action: choose_player_action).start).to eq(:push_by_points)
    end
  end
end
