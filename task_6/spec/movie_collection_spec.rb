require_relative '../netfix'
require 'csv'

describe MovieCollection do

  let(:movie_collection) {MovieCollection.read}

  it { expect(movie_collection).to be_instance_of MovieCollection}

  describe '#films_by_producers' do
    subject {movie_collection.films_by_producers}
    it { is_expected.to be_instance_of Hash}
    it { is_expected.to all(be_instance_of Array)}
  end

end