require_relative 'spec_helper'

describe Movie do 
  let(:ary) { MoviePack::REC_HEADERS } 
  let(:hash) { CSV.read(MoviePack::MOVIEFILE, col_sep: '|', headers: ary)[0] }
  let(:movie) { Movie.new(hash) }

  it { expect(movie.year).to be_instance_of Fixnum }
  it { expect(movie.rating).to be_instance_of Float }
  it { expect(movie.duration).to be_instance_of Fixnum }

  describe '#match?' do
  	let(:checking_genres) {movie.genre.first(1) << "Bla-bla" }
    it { expect(movie).to respond_to(:match?).with(2).arguments }
  	it { expect(movie.match?(:year, movie.year)).to be_truthy }
  	it { expect(movie.match?(:actors, movie.actors[0])).to be_truthy }
    it { expect(movie.match?(:genre, checking_genres)).to be_truthy }
    it { expect(movie.match?(:year, (movie.year-1)..(movie.year+1))).to be true }
  end

  describe '#to_s' do
    it { expect(movie.to_s).to eq("#{movie.title}, #{movie.year}, #{movie.country}, #{movie.genre.join(', ')}, #{movie.duration} min, raitng: #{movie.rating}, producer: #{movie.producer}, starring: #{movie.actors.join(', ')}") }
  end

  describe '#has_genre?' do
    context 'when no host' do
      it { expect(movie.has_genre?(movie.genre)).to be true }
      it { expect(movie.has_genre?(movie.genre.first)).to be true }
      it { expect(movie.has_genre?('Tragedy')).to be false }
    end

    context 'when with host' do
      let(:host) { MovieCollection.read }
      let(:movie_with_host) { Movie.new(hash, host) }
      it { expect { movie_with_host.has_genre?('Tragedy') }.to raise_error(ArgumentError) }
    end
  end
end