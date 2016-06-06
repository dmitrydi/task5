require_relative '..\new_movie'
require 'csv'
require 'date'

describe NewMovie do

  let(:this_year) {Date.today.year}
  let(:record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[4].to_i.between?(2001, this_year)}}
  let(:bad_record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[4].to_i.between?(1945,1968)}}
  let(:new_movie) {NewMovie.new(record)}

  it{ expect{NewMovie.new(bad_record)}.to raise_error(ArgumentError) }

  it{ expect(new_movie.to_s).to eq("#{new_movie.title} - new film, released #{(this_year - new_movie.year.to_i)} years ago!") }

end