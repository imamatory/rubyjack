# frozen_string_literal: true

RSpec.describe(Rubyjack::Dealer) do
  Card = Rubyjack::Card
  Hand = Rubyjack::Hand
  Shoe = Rubyjack::Shoe

  let(:ace) { Card.new(suit: :spades, type: :ace) }
  let(:king) { Card.new(suit: :diamonds, type: :king) }
  let(:four) { Card.new(suit: :diamonds, type: 4) }
  let(:two) { Card.new(suit: :diamonds, type: 2) }
  let(:three) { Card.new(suit: :diamonds, type: 3) }
  let(:six) { Card.new(suit: :diamonds, type: 6) }
  let(:ten) { Card.new(suit: :hearts, type: 10) }

  describe 'dealer turn' do
    let(:shoe) { Shoe.new(cards: [four, ten, king]) }
    let(:dealer) { described_class.new }

    it 'hits 2 cards initialy' do
      dealer.turn(shoe)
      expect(dealer.hand).to eq(Hand.new([king, ten]))
    end
  end

  describe 'dealer hits card until sum is < 17 ' do
    let(:shoe_light) { Shoe.new(cards: [six, two, four, six, two]) }
    let(:shoe_medium) { Shoe.new(cards: [four, ten, three]) }
    let(:shoe_hard) { Shoe.new(cards: [king, ten, six]) }
    let(:dealer) { described_class.new }

    it 'hits cards from shoe until get fit' do
      dealer.turn(shoe_light)
      dealer.turn(shoe_light)
      expect(dealer.hand).to eq(Hand.new([two, six, four, two, six]))
    end

    it 'hits cards until get 17' do
      dealer.turn(shoe_medium)
      dealer.turn(shoe_medium)
      expect(dealer.hand).to eq(Hand.new([three, ten, four]))
    end

    it 'hits cards until get bust' do
      dealer.turn(shoe_hard)
      dealer.turn(shoe_hard)
      expect(dealer.hand).to eq(Hand.new([six, ten, king]))
    end
  end
end
