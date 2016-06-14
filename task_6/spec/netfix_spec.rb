require_relative '../netfix'

describe Netfix do

  let(:netfix) {Netfix.read}
  before (:example) do
    netfix.pay(10)
  end

  describe '#select_movie' do
    it { expect{Netfix.read.select_movie}.to raise_error(RuntimeError, "you don't have enough money") }
    it { expect{netfix.select_movie(genre: 'Tragedy')}.to raise_error(ArgumentError) }
    it { expect{netfix.select_movie}.not_to raise_error(RuntimeError, "you don't have enough money") }
    it { expect(netfix.select_movie(period: 'ancient')).to be_instance_of AncientMovie }
  end

  describe '#show' do
    it {expect{netfix.show(period: 'ancient')}.to change{netfix.money}.from(10).to(10 - AncientMovie::PRICE) }
    it {expect{netfix.show(period: 'ancient')}.to output(/Now showing.*old movie/).to_stdout }
  end

end