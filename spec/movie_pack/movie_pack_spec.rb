require_relative '../../lib/movie_pack'

describe MoviePack do 
  
  describe MoviePack::Movie do
    let(:record) { CSV.read(MoviePack::MOVIEFILE, col_sep: '|')[0] }
    let(:movie) {MoviePack::Movie.new(record)}

    it{ expect(movie).to be_instance_of MoviePack::Movie }
    #it{ expect(movie).to have_attribute(:webaddr => record[0]) }
  end
  
end