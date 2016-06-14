require_relative '../movie'
#require_relative '../movies.txt'
require 'csv'

describe Movie do 
  let(:record) {CSV.read('../movies.txt', col_sep: '|')[0]}
  let(:movie) {Movie.new(record)}

  it {expect(movie.year).to be_instance_of Fixnum}
  it {expect(movie.rating).to be_instance_of Float}
  it {expect(movie.duration).to be_instance_of Fixnum}


  
end