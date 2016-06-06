require_relative '..\modern_movie'
require 'csv'

describe ModernMovie do

  let(:record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[4].to_i.between?(1968,2000)}}
  let(:bad_record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[4].to_i.between?(1945,1968)}}
  let(:modern_movie) {ModernMovie.new(record)}

  it{ expect{ModernMovie.new(bad_record)}.to raise_error(ArgumentError) }

  it{ expect(modern_movie.to_s).to include("modern movie, starring:") }

end