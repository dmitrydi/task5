require_relative 'movies_shared_spec'

describe ClassicMovie do
  it_behaves_like "a movie with limited period and certain price", 1946, 1968, 'classic', 1.5

  describe '#to_s' do
  	context 'when initialized without @host' do
  	  include_examples "prepare an instance", 1946, 1968, :classic_movie
  	  it { expect(classic_movie.to_s).to eq("#{classic_movie.title} - classic movie, producer: #{classic_movie.producer} (really good one)") }
  	end
  end

end