require_relative 'spec_helper'

describe AncientMovie do

  period = AncientMovie::PERIOD

  let(:ancient_movie) {make_movie(described_class)}

  it_behaves_like "a movie with limited period and certain price", period, 'ancient', 1

  describe '#to_s' do
  	it { expect(ancient_movie.to_s).to eq("#{ancient_movie.title} - old movie (#{ancient_movie.year})") }
  end

end
  