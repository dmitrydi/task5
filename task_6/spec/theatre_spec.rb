require_relative '../theatre'

describe Theatre do

  let(:theatre) { Theatre.read }

  before (:example) do
    theatre.pay(10)
  end
  
  describe '#select_movie' do
    it{ expect{Theatre.new.select_movie}.to raise_error(ArgumentError) }
    it{ expect(theatre.select_movie('08:30')).to have_attributes(:period => 'ancient') }
    it{ expect(theatre.select_movie('12:30').genre).to include('Comedy').or include('Adventure') }
    it{ expect(theatre.select_movie('18:30').genre).to include('Drama').or include('Horror') }
    it{ expect{theatre.select_movie('03:30')}.to raise_error(ArgumentError)}
  end

  describe '#show' do
    it{ expect{theatre.show}.to raise_error(ArgumentError) }
    it {expect{theatre.show('08:30')}.to change{theatre.money}.from(10).to(10 - AncientMovie::PRICE) }
    it{ expect{theatre.show('08:30')}.to output(/Now showing.*old movie/).to_stdout } 
  end
  
end