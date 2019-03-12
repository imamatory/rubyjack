# frozen_string_literal: true

RSpec.describe(Rubyjack::Shoe) do
  let(:amount_of_decks) { 3 }
  let(:amount_of_cards) { 3 * 52 }
  let(:ace) { Card.new(suit: :spades, type: :ace) }
  let(:king) { Card.new(suit: :diamonds, type: :king) }
  let(:four) { Card.new(suit: :diamonds, type: 4) }

  describe 'shoe' do
    it 'generates cards in shoe' do
      expect(described_class.new(amount_of_decks: amount_of_decks).cards_left).to eq(amount_of_cards)
    end

    it 'hits one card' do
      expect(described_class.new(cards: [ace, king]).hit!).to eq(king)
    end
  end
end
