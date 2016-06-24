require_relative 'spec_helper'

describe Netfix do

  let(:netfix) {Netfix.read}
  before (:example) do
    Netfix.take('Bank')
    netfix.pay(10)
  end
  
  it { expect(Netfix.cash).to eq(10) }
  it { expect{ Netfix.read.pay(10) }.to change{Netfix.cash}.by(10) }

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
    context 'it works well without blocks' do
      it { expect{Netfix.read.select_movie}.to raise_error(RuntimeError, "You don't have enough money") }
      it { expect{netfix.select_movie(genre: 'Tragedy')}.to raise_error(ArgumentError) }
      it { expect{netfix.select_movie}.not_to raise_error(RuntimeError, "You don't have enough money") }
      it { expect(netfix.select_movie(period: 'ancient')).to be_instance_of AncientMovie }
    end

    context 'it work well with block' do
      it { expect(netfix.select_movie{ |m| !m.title.include?('Terminator') && m.genre.include?('Action') } ).to not_include_in_attribute(:title, 'Terminator').and include_in_attribute(:genre, 'Action') }
    end

    context 'it works with user-defined block filters' do
      before(:example) do
        netfix.define_filter(:new_sci_fi) { |m| m.genre.include?('Sci-Fi') && m.period == 'new' }
      end
      it { expect(netfix.select_movie(new_sci_fi: true)).to include_in_attribute(:genre, 'Sci-Fi').and include_in_attribute(:period, 'new') }
    end

    context 'it works with user-defined blocks with parameters' do
      before(:example) do
        netfix.define_filter(:new_sci_fi) { |movie, year| movie.year > year && movie.genre.include?('Sci-Fi') }
      end
      it { expect(netfix.select_movie(new_sci_fi: 2003).year).to be > 2003 }
      it { expect(netfix.select_movie(new_sci_fi: 2003, country: 'USA')).to include_in_attribute(:genre, 'Sci-Fi').and include_in_attribute(:country, 'USA') }
    end
  end

  describe '#show' do
    it {expect{netfix.show(period: 'ancient')}.to change{netfix.money}.by(- AncientMovie::PRICE) }
    it {expect{netfix.show(period: 'ancient')}.to output(/Now showing.*old movie/).to_stdout }

    context 'it works with blocks' do
      it { expect{ netfix.show { |m| m.period == 'ancient' } }.to output(/Now showing.*old movie/).to_stdout }
    end
  end

  describe '#define_filter' do
    before (:example) do
      netfix.define_filter(:new_sci_fi) { |m| m.genre.include?('Sci-Fi') && m.period == 'new' }
    end
    it { expect(netfix.filter_store).not_to be_empty }
  end

end