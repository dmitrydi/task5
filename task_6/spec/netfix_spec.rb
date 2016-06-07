require_relative '../netfix'
require_relative '../movie_classes'
require_relative 'netfix_shared_spec'


describe Netfix do

  let(:netfix) {Netfix.read}

  describe '#read' do
    include_examples "creates a collection of diff.movies", Netfix.new.read
  end

  describe 'self.read' do
    include_examples "creates a collection of diff.movies", Netfix.read
  end

  describe '#pay' do
    it { expect{netfix.pay(-1)}.to raise_error(ArgumentError, "argument should be >=0") }
    it { expect{netfix.pay(10)}.to change{netfix.money}.from(0).to(10) }
    it { expect(netfix.pay(10)).to be_instance_of Netfix }
  end

  describe '#films_by_producers' do
    subject {netfix.films_by_producers}
    it { is_expected.to be_instance_of Hash}
    it { is_expected.to all(be_instance_of Array)}
  end

  describe '#make_shortlist' do

    it { expect(netfix.make_shortlist).to be_instance_of Array }

    context 'when money = 0 returns an empty array' do
      it { expect(netfix.make_shortlist).to be_empty }
    end

    context 'when sufficient money array of movies is not empty' do
      #it { expect(@netfix.pay(10).make_shortlist).not_to be_empty}
    end

    context 'when money = 1 return only array of AncientMovie' do
      it { expect(netfix.pay(1).make_shortlist[0]).to be_instance_of AncientMovie }
    end
  end





end