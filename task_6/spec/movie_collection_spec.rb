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

  describe '#filter' do
  	it 'is expected to deal with integer keys' do
  	  expect(movie_collection.filter(year: 1994).collection).to all(have_attributes(:year => 1994))
  	end
    it 'is expected to deal with other classes of keys' do
      expect(movie_collection.filter(country: 'USA').collection).not_to all(have_attributes(:country => 'Germany'))
    end
  end


end