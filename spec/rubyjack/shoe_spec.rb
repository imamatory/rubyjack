# frozen_string_literal: true

RSpec.describe(Rubyjack::Shoe) do
  # FIXME: how to alias modules properly?
  Card = Rubyjack::Card

  let(:amount_of_decks) { 3 }
  let(:amount_of_cards) { 3 * 52 }
  let(:ace) { Card.new(suit: :spades, type: :A) }
  let(:king) { Card.new(suit: :diamonds, type: :K) }
  let(:four) { Card.new(suit: :diamonds, type: 4) }

  describe 'shoe' do
    it 'generates cards in shoe' do
      expect(described_class.new(amount_of_decks: amount_of_decks).cards_left).to eq(amount_of_cards)
    end

    it 'hits one card' do
      expect(described_class.new(cards: [ace, king]).hit!).to eq(king)
    end

    it 'hits two cards' do
      expect(described_class.new(cards: [ace, four]).hit!(2)).to eq([four, ace])
    end
  end

  describe 'shuffle' do
    let(:shoe1) { described_class.new(amount_of_decks: amount_of_decks).shuffle! }
    let(:shoe2) { described_class.new(amount_of_decks: amount_of_decks).shuffle! }

    it 'tests shuffle' do
      expect(shoe1.hit!(amount_of_decks)).not_to eq(shoe1.hit!(amount_of_decks))
    end
  end
end
