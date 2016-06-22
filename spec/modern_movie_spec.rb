require_relative 'movies_shared_spec'

describe ModernMovie do

  period = ModernMovie::PERIOD

  let(:modern_movie) {make_movie(described_class)}

  it_behaves_like "a movie with limited period and certain price", period, 'modern', 3

  describe '#to_s' do
    it { expect(modern_movie.to_s).to eq("#{modern_movie.title} - modern movie, starring: #{modern_movie.actors.join(', ')}") }
  end
end