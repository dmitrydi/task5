require_relative '../netfix'
require_relative '../movie_classes'
require_relative 'netfix_shared_spec'


describe Netfix do

  let(:netfix) {Netfix.read}

  describe '#read' do
    include_examples "creates a collection of diff.movies", Netfix.new.read
  end

  describe '#self.read' do
    it {expect(netfix).to be_instance_of Netfix}
  end

  describe '#pay' do
    it { expect{netfix.pay(-1)}.to raise_error(ArgumentError, "argument should be >=0") }
    it { expect{netfix.pay(10)}.to change{netfix.money}.from(0).to(10) }
    it { expect(netfix.pay(10)).to be_instance_of Netfix }
  end

  describe '#make_shortlist' do

    it { expect(netfix.make_shortlist).to be_instance_of Array }

    context 'when money = 0 returns an empty array' do
     it { expect(netfix.make_shortlist.length).to eq(0) }
    end

    context 'it raise error with bad filter' do
      it { expect{netfix.make_shortlist(genre: 'Tragedy')}.to raise_error(ArgumentError)}
    end

    context 'when sufficient money array of movies is not empty' do
      it { expect(netfix.pay(10).make_shortlist).not_to be_empty}
    end

    context 'when money = 1 return only array of AncientMovie' do
      it { expect(netfix.pay(1).make_shortlist).to all(be_instance_of(AncientMovie)) }
    end

    context 'filters by period' do
      it { expect(netfix.pay(10).make_shortlist(period: 'ancient')).to all(be_instance_of(AncientMovie)) }
    end

    context 'works with filters' do
      it { expect(netfix.pay(10).make_shortlist(country: 'USA')).to all(have_attributes(:country => 'USA')) }
    end

    context 'when money = 1.5 return array of Ancient and Classic movies' do
      it { expect(netfix.pay(1.5).make_shortlist).to all(be_instance_of(AncientMovie) | be_instance_of(ClassicMovie)) }
    end

  end

  describe '#how_much?' do
    it 'expect to return right price' do
      price = netfix.filter(title: "The Terminator").collection.first.price
      expect(netfix.how_much?("The Terminator")).to eq(price) 
    end
    it { expect{netfix.how_much?("Santa Barbara")}.to raise_error(ArgumentError)}
  end

end