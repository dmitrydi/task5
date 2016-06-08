require_relative '..\movie_classes'
require 'csv'

describe AncientMovie do

  let(:record) { CSV.read('../movies.txt', col_sep: '|').map.find{|a| AncientMovie::PERIOD.include?(a[2].to_i)} }
  let(:bad_record) { CSV.read('../movies.txt', col_sep: '|').map.find{|a| !(AncientMovie::PERIOD.include?(a[2].to_i))} }
  let(:ancient_movie) {AncientMovie.new(record)}

  it { expect(record).not_to be_nil }
  it { expect(AncientMovie::PERIOD).to eq(1900..1945)}
  it { expect{AncientMovie.new(bad_record)}.to raise_error(ArgumentError) }
  it { expect{ancient_movie}.not_to raise_error }

  describe '#period' do
  	it "returns 'ancient' value" do
  	  expect(ancient_movie.period).to eq('ancient')
  	end
  end

  describe '#price' do
  	it "returns 1" do
  	  expect(ancient_movie.price).to eq(1)
  	end
  end

  describe '#to_s' do
  	it "returns a string '#{@title} - old movie (#{@year})' " do
  	  expect(ancient_movie.to_s).to eq("#{ancient_movie.title} - old movie (#{ancient_movie.year})")
    end
  end

end
  