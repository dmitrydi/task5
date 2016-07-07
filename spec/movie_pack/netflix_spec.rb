require_relative 'spec_helper'

describe Netflix do

  let(:netflix) {Netflix.read}
  before (:example) do
    Netflix.take('Bank')
    netflix.pay(10)
  end
  
  it { expect(Netflix.cash).to eq(10) }
  it { expect{ Netflix.read.pay(10) }.to change{Netflix.cash}.by(10) }

  describe '#pay' do
    it { expect{netflix.pay(-1)}.to raise_error(ArgumentError, "argument should be >=0") }
    it { expect{netflix.pay(10)}.to change{netflix.money}.from(10).to(20) }
  end

  describe '#price_for' do
    let(:price) { netflix.filter(title: "The Terminator").collection.first.price }
    it 'expect to return right price' do
      expect(netflix.price_for("The Terminator")).to eq(price) 
    end
    it { expect{netflix.price_for("Santa Barbara")}.to raise_error(ArgumentError)}
  end

  describe '#select_movie' do
    context 'it works well without blocks' do
      it { expect{Netflix.read.select_movie}.to raise_error(RuntimeError, "You don't have enough money") }
      it { expect{netflix.select_movie(genre: 'Tragedy')}.to raise_error(ArgumentError) }
      it { expect{netflix.select_movie}.not_to raise_error(RuntimeError, "You don't have enough money") }
      it { expect(netflix.select_movie(period: 'ancient')).to be_instance_of AncientMovie }
    end

    context 'it work well with block' do
      it { expect(netflix.select_movie{ |m| !m.title.include?('Terminator') && m.genre.include?('Action') } ).to not_include_in_attribute(:title, 'Terminator').and include_in_attribute(:genre, 'Action') }
    end

    context 'it works with user-defined block filters' do
      before(:example) do
        netflix.define_filter(:new_sci_fi) { |m| m.genre.include?('Sci-Fi') && m.period == 'new' }
      end
      it { expect(netflix.select_movie(new_sci_fi: true)).to include_in_attribute(:genre, 'Sci-Fi').and include_in_attribute(:period, 'new') }
    end

    context 'it works with user-defined blocks with parameters' do
      before(:example) do
        netflix.define_filter(:new_sci_fi) { |year, movie| movie.year > year && movie.genre.include?('Sci-Fi') }
      end
      it { expect(netflix.select_movie(new_sci_fi: 2003).year).to be > 2003 }
      it { expect(netflix.select_movie(new_sci_fi: 2003, country: 'USA')).to include_in_attribute(:genre, 'Sci-Fi').and include_in_attribute(:country, 'USA') }
    end

    context 'it works with user-defined blocks derived from existing blocks' do
      before(:example) do
        netflix.define_filter(:new_sci_fi) { |year, movie| movie.year > year && movie.genre.include?('Sci-Fi') }
        netflix.define_filter(:newest_sci_fi, from: :new_sci_fi, arg: 2010)
      end
      it { expect(netflix.select_movie(newest_sci_fi: true).year).to be > 2010 }
    end

    context 'it works with array of params' do
      before(:example) do
        netflix.define_filter(:new_filter) { |year, genre, movie| movie.year > year && movie.genre.include?(genre) }
      end
      it { expect(netflix.select_movie(new_filter: [2003, 'Comedy'])).to include_in_attribute(:genre, 'Comedy') }
    end

    context 'it works with arrays in plain filters' do
      it { expect(netflix.select_movie(genre: ['Comedy', 'Adventure'])).to include_in_attribute(:genre, 'Comedy').or include_in_attribute(:genre, 'Adventure') }
    end

  end

  describe '#show' do
    it {expect{netflix.show(period: 'ancient')}.to change{netflix.money}.by(- AncientMovie::PRICE) }
    it {expect{netflix.show(period: 'ancient')}.to output(/Now showing.*old movie/).to_stdout }

    context 'it works with blocks' do
      it { expect{ netflix.show { |m| m.period == 'ancient' } }.to output(/Now showing.*old movie/).to_stdout }
    end
  end

  describe '#define_filter' do
      before (:example) do
        netflix.define_filter(:new_sci_fi) { |m| m.genre.include?('Sci-Fi') && m.period == 'new' }
        netflix.define_filter(:new_sci_fi_2) { |year, movie| movie.year > year && movie.genre.include?('Sci-Fi') }
        netflix.define_filter(:newest_sci_fi, from: :new_sci_fi_2, arg: 2010)
      end
      it { expect(netflix.filter_store).not_to be_empty }
      it { expect(netflix.filter_store[:newest_sci_fi]).to be_instance_of Proc }
      it { expect{ netflix.define_filter(:bad_filter, from: :nonexistent_filter) }.to raise_error ArgumentError }
  end

  describe '#by_genre' do
    it { expect(netflix.by_genre).to be_instance_of Netflix::GenreContainer }
  end

  describe 'Netflix::Container#comedy' do
    it { expect(netflix.by_genre.comedy).to all(include_in_attribute(:genre, 'Comedy')) }
    it { expect(netflix.by_genre.drama).to all(include_in_attribute(:genre, 'Drama')) }
    it { expect { netflix.by_genre.tragedy }.to raise_error(NoMethodError) }
  end

  describe 'Netflix::Container#usa' do
    it { expect(netflix.by_country.usa).to all(include_in_attribute(:country, 'USA')) }
    it { expect(netflix.by_country.bad_country).to eq([]) }
  end
end