require_relative '..\classic_movie'
require 'csv'


describe ClassicMovie do

  let(:record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[4].to_i.between?(1946,1968)}}
  let(:bad_record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[4].to_i.between?(1969,2000)}}
  let(:classicmovie) {ClassicMovie.new(record)}

  it{ expect{ClassicMovie.new(bad_record)}.to raise_error(ArgumentError) }

  it{ expect(classicmovie.to_s).to include("classic movie, producer") }

end