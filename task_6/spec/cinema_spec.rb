require_relative '../cinema'
require_relative '../movie_classes'
require_relative 'cinema_shared_spec'


describe Cinema do

  let(:cinema) {Cinema.read}

  describe '#read' do
    include_examples "creates a collection of diff.movies", Cinema.new.read
  end

  subject{cinema}

  describe '#self.read' do
    it { is_expected.to be_instance_of Cinema }
  end

  describe '#pay' do
    it { expect{cinema.pay(-1)}.to raise_error(ArgumentError, "argument should be >=0") }
    it { expect{cinema.pay(10)}.to change{cinema.money}.from(0).to(10) }
    it { expect(cinema.pay(10)).to be_instance_of Cinema }
  end

  describe '#price_for' do
    let(:price) { cinema.filter(title: "The Terminator").collection.first.price }
    it 'expect to return right price' do
      expect(cinema.price_for("The Terminator")).to eq(price) 
    end
    it { expect{cinema.price_for("Santa Barbara")}.to raise_error(ArgumentError)}
  end

  describe '#filter_by_price' do
    it { expect(cinema.pay(3).filter_by_price(cinema.money).collection).to all have_price(1..3)}
  end

  describe '#inspect' do
    subject {cinema.inspect}
    it { is_expected.to be_instance_of String }
    it { is_expected.to include("ancient", "classic", "new", "modern")}
  end

end