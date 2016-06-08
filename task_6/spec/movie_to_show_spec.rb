require_relative '../movie_classes'
require_relative '../netfix'
require_relative 'movies_shared_spec'
require 'csv'
require 'date'

describe MovieToShow do

  let(:record) {CSV.read('../movies.txt', col_sep: '|')[0]}
  let(:movie) { MovieToShow.new(record) }
  let(:ancient_record) { CSV.read('../movies.txt', col_sep: '|').map.find{|a| AncientMovie::PERIOD.include?(a[2].to_i)} }

  describe '#check_year' do
    it { expect{movie.check_year(1900)}.not_to raise_error }
  end

  describe '#create' do
    it 'creates an AncientMovie instance when period is ancient' do
      expect(MovieToShow.create(ancient_record)).to be_instance_of AncientMovie
    end
  end



end
