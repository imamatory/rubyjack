# frozen_string_literal: true

RSpec.describe(Rubyjack::Hand) do
  # FIXME: how to alias modules properly?
  Card = Rubyjack::Card

  let(:ace) { Card.new(suit: :spades, type: :A) }
  let(:king) { Card.new(suit: :diamonds, type: :K) }
  let(:four) { Card.new(suit: :diamonds, type: 4) }
  let(:ten) { Card.new(suit: :hearts, type: 10) }

  describe ' counting hand' do
    it 'counts empty hand' do
      expect(described_class.new.sum).to eq(0)
    end
    it 'counts non empty hand' do
      expect(described_class.new(cards: [king]).sum).to eq(10)
    end
    it 'counts hand with < 21' do
      expect(described_class.new(cards: [king, four]).sum).to eq(14)
    end
    it 'counts hand with > 21' do
      expect(described_class.new(cards: [king, ten, four]).sum).to eq(24)
    end
    it 'counts hand with ace and < 10' do
      expect(described_class.new(cards: [four, ace]).sum).to eq(15)
    end
    it 'counts hand with two aces and < 21' do
      expect(described_class.new(cards: [ace, ace]).sum).to eq(12)
    end
    it 'counts hand with two aces and > 21' do
      expect(described_class.new(cards: [ace, king, ace]).sum).to eq(12)
    end
    it 'counts hand with blackjack' do
      expect(described_class.new(cards: [ace, king]).sum).to eq(21)
    end
    it 'counts hand with ace and hard hand' do
      expect(described_class.new(cards: [four, ace, king]).sum).to eq(15)
    end
  end
end
