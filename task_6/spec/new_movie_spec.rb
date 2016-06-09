require_relative 'movies_shared_spec'
require 'date'

describe NewMovie do

  period = NewMovie::PERIOD

  it_behaves_like "a movie with limited period and certain price", period, 'new', 5

  describe '#to_s' do
    include_examples "prepare an instance", period, :new_movie
    
    it "expected to return right string" do
      years_ago = Date.today.year - new_movie.year
      expect(new_movie.to_s).to eq("#{new_movie.title} - new film, released #{years_ago} years ago!") 
    end

  end

end