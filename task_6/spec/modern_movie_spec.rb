require_relative 'movies_shared_spec'

describe ModernMovie do
  it_behaves_like "a movie with limited period and certain price", 1969..2000, 'modern', 3

  describe '#to_s' do
    include_examples "prepare an instance", 1969..2000, :modern_movie
    it { expect(modern_movie.to_s).to eq("#{modern_movie.title} - modern movie, starring: #{modern_movie.actors.join(', ')}") }
  end
end