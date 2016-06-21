require_relative '..\lib\netfix'
require_relative '..\lib\cash_desk'

describe Netfix do

  let(:netfix) {Netfix.read}
  before (:example) do
    netfix.pay(10)
  end
  
  it { expect(Netfix.cash).to eq(10) }
  it { expect{ Netfix.read.pay(10) }.to change{Netfix.cash}.by(10) }
  it { expect{ Netfix.put_cash(-10) }.to raise_error ArgumentError }

  describe '#pay' do
    it { expect{netfix.pay(-1)}.to raise_error(ArgumentError, "argument should be >=0") }
    it { expect{netfix.pay(10)}.to change{netfix.money}.from(10).to(20) }
  end

  describe '#price_for' do
    let(:price) { netfix.filter(title: "The Terminator").collection.first.price }
    it 'expect to return right price' do
      expect(netfix.price_for("The Terminator")).to eq(price) 
    end
    it { expect{netfix.price_for("Santa Barbara")}.to raise_error(ArgumentError)}
  end

  describe '#select_movie' do
    it { expect{Netfix.read.select_movie}.to raise_error(RuntimeError, "You don't have enough money") }
    it { expect{netfix.select_movie(genre: 'Tragedy')}.to raise_error(ArgumentError) }
    it { expect{netfix.select_movie}.not_to raise_error(RuntimeError, "You don't have enough money") }
    it { expect(netfix.select_movie(period: 'ancient')).to be_instance_of AncientMovie }
  end

  describe '#show' do
    it {expect{netfix.show(period: 'ancient')}.to change{netfix.money}.by(- AncientMovie::PRICE) }
    it {expect{netfix.show(period: 'ancient')}.to output(/Now showing.*old movie/).to_stdout }
  end

end