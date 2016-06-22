require_relative '../../lib/movie_pack'

describe MoviePack do 
  
  describe MoviePack::Movie do
    let(:record) { CSV.read(MoviePack::MOVIEFILE, col_sep: '|')[0] }
    let(:movie) {MoviePack::Movie.new(record)}

    it{ expect(movie).to be_instance_of MoviePack::Movie }
    it{ expect(movie).to respond_to(:webaddr, :title, :year, :country, :date, :genre, :duration, :rating, :producer, :actors, :month) }

    describe '#has_genre?' do
      context 'when initialized without host' do
        it{ expect(movie.has_genre?(movie.genre)).to be_truthy }
        it{ expect(movie.has_genre?(movie.genre[0])).to be_truthy }
        it{ expect(movie.has_genre?('Tragedy')).to be false }
      end

      context 'when initialized with host' do
        let(:movie_collection) { MoviePack::MovieCollection.read }
        let(:movie_with_host) { MoviePack::Movie.new( record, movie_collection ) }
        it{ expect{ movie_with_host.has_genre?('Tragedy') }.to raise_error ArgumentError }
      end
    end

    describe '#match?' do
      it{ expect(movie.match?(:webaddr, movie.webaddr)).to be true }
      it{ expect(movie.match?(:actors, movie.actors)).to be true }
      it{ expect(movie.match?(:actors, movie.actors[0])).to be true }
      it{ expect(movie.match?(:actors, movie.actors + ["something"])).to be true }
      it{ expect(movie.match?(:actors, "something")).to be false }
    end
  end
  
end