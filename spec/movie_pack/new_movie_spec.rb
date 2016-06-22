require_relative 'spec_helper'

describe NewMovie do

  period = NewMovie::PERIOD

  let(:new_movie) {make_movie(described_class)}

  it_behaves_like "a movie with limited period and certain price", period, 'new', 5

  describe '#to_s' do
  	it { expect(new_movie.to_s).to eq("#{new_movie.title} - new film, released #{Date.today.year - new_movie.year} years ago!") }
  end

end