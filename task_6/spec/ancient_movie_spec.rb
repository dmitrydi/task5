require_relative 'movies_shared_spec'

describe AncientMovie do

  period = AncientMovie::PERIOD

  it_behaves_like "a movie with limited period and certain price", period, 'ancient', 1

  describe '#to_s' do
    include_examples "prepare an instance", period, :ancient_movie
  	it "returns a string '#{@title} - old movie (#{@year})' " do
  	  expect(ancient_movie.to_s).to eq("#{ancient_movie.title} - old movie (#{ancient_movie.year})")
    end
  end

end
  