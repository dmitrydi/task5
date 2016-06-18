require_relative '../movie'
#require_relative '../movies.txt'
require 'csv'

describe Movie do 
  let(:record) {CSV.read('../movies.txt', col_sep: '|')[0]}
  let(:movie) {Movie.new(record)}

  it {expect(movie.year).to be_instance_of Fixnum}
  it {expect(movie.rating).to be_instance_of Float}
  it {expect(movie.duration).to be_instance_of Fixnum}

  describe '#match?' do
  	it { expect(movie).to respond_to(:match?).with(2).arguments }
  	it { expect(movie.match?(:year, movie.year)).to be_truthy }
  	it { expect(movie.match?(:actors, movie.actors[0])).to be_truthy }
  end

  describe '#any_match?' do
    let(:checking_genres) {movie.genre.first(1) << "Bla-bla" }
    it { expect(movie.any_match?(:genre, checking_genres)).to be_truthy }
  end
end