require_relative '..\lib\theatre'

describe Theatre do

  let(:theatre) { Theatre.read }
  
  describe '#select_movie' do
    it{ expect{Theatre.new.select_movie}.to raise_error(ArgumentError) }
    it{ expect(theatre.select_movie('08:30')).to have_attributes(:period => 'ancient') }
    it{ expect(theatre.select_movie('12:30').genre).to include('Comedy').or include('Adventure') }
    it{ expect(theatre.select_movie('18:30').genre).to include('Drama').or include('Horror') }
    it{ expect{theatre.select_movie('03:30')}.to raise_error(ArgumentError)}
  end

  describe '#show' do
    it{ expect{theatre.show}.to raise_error(ArgumentError) }
    it{ expect{theatre.show('08:30')}.to output(/Now showing.*old movie/).to_stdout } 
  end

  describe '#time_for' do
    let(:ancient_title) { theatre.filter(period: 'ancient').collection.first.title }
    let(:comedy_title) { theatre.filter(genre: 'Comedy').collection.first.title }
    let(:drama_title) { theatre.filter(genre: 'Drama').collection.first.title }
    let(:right_genres) { ['Comedy', 'Adventure',  'Drama', 'Horror'] }
    let(:bad_title) { theatre.collection.find_all{|a| a.period != 'ancient'}.find{ |a| right_genres.inject(true) { |m , v| m && !a.genre.include?(v) } }.title }
    it{ expect(theatre.time_for(ancient_title)).to be_between("08:00", "11:00") }
    it{ expect(theatre.time_for(comedy_title)).to be_between("12:00", "17:00") }
    it{ expect(theatre.time_for(drama_title)).to be_between("18:00", "23:00").or be_between("00:00", "02:00")}
    it{ expect{theatre.time_for(bad_title)}.to raise_error(ArgumentError, "Film is not in the schedule") }
  end

  it { expect(theatre.cash).to eq 0 }

  describe '#buy_ticket' do

    it { expect{theatre.buy_ticket("09:30")}.to change{theatre.cash}.by(AncientMovie::PRICE) }
    it { expect{Theatre.read.buy_ticket("09:30")}.not_to change{theatre.cash} }
  end
  
end