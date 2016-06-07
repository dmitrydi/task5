require_relative 'movies_shared_spec'

describe AncientMovie do

  it_behaves_like "a movie with limited period and certain price", 1900, 1945, 'ancient', 1

  describe '#to_s' do
    include_examples "prepare an instance", 1900, 1945, :movie
    it { expect(movie.to_s).to eq("#{movie.title} - old movie (#{movie.year})") }
  end

end
  