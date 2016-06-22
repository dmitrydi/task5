require_relative '..\..\lib\movie_pack'
require 'csv'

RSpec.shared_examples "a movie with limited period and certain price" do |year_range, expected_period, expected_price|
  let(:movies_file) {MoviePack::MOVIEFILE}
  let(:record) {CSV.read(movies_file, col_sep: "|").map.find{|a| year_range.include?(a[2].to_i)}}
  let(:bad_record) {CSV.read(movies_file, col_sep: "|").map.find{|a| !(year_range.include?(a[2].to_i))}}
  let(:movie) {described_class.new(record)}

  it{ expect(movie).to be_an_instance_of described_class }

  describe "#initialize and #check_year" do 
    it {expect{described_class.new(bad_record)}.to raise_error(ArgumentError)}
  end 

  describe '#period' do
    it "returns appriopriate value" do
      expect(movie.period).to eq(expected_period)
    end
  end

  describe '#price' do
    it "returns right price" do
      expect(movie.price).to eq(expected_price)
    end
  end

end

RSpec.shared_examples "creates a movie of appropriate class" do |year_range, class_name|
  let(:record) {CSV.read(MoviePack::MOVIEFILE, col_sep: "|").map.find{|a| year_range.include?(a[2].to_i)}}
  it { expect(described_class.create(record)).to be_an_instance_of class_name }
end

def make_movie(movie_class, host = nil)
  record = CSV.read(MoviePack::MOVIEFILE, col_sep: "|").map.find{ |a| movie_class::PERIOD.include?(a[2].to_i) }
  movie_class.new(record, host)
end




