require_relative '..\movie_classes'
require 'csv'


describe AncientMovie do

  let(:record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[4].to_i.between?(1900,1945)}}
  let(:bad_record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[4].to_i.between?(1946,1968)}}
  let(:ancient_movie) {AncientMovie.new(record)}

  it{ expect(record[4].to_i).to be_between(1900,1945).inclusive }
  it{ expect(bad_record[4].to_i).not_to be_between(1900,1945).inclusive }

  it{ expect(AncientMovie.new(record)).to be_an_instance_of AncientMovie }
  it{ expect{AncientMovie.new(bad_record)}.to raise_error(ArgumentError) }

  it{ expect(ancient_movie.to_s).to include("old movie") }

end