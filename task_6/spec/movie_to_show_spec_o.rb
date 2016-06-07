require_relative '../movie_classes'
require_relative '../netfix'
require_relative 'movies_shared_spec'
require 'csv'
require 'date'

describe MovieToShow do

  let(:record) {CSV.read('../movies.txt', col_sep: '|')[0]}
  let(:ancient_record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[2].to_i.between?(1900,1945)}}
  let(:classic_record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[2].to_i.between?(1946,1968)}}
  #let(:modern_record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[2].to_i.between?(1969,2000)}}
  #let(:new_record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[2].to_i.between?(2001, Date.today.year)}}
  let(:movieshow) {MovieToShow.new(record)}

  it { expect{movieshow.right_year?(movieshow.year.to_i - 1, movieshow.year.to_i + 1)}.not_to raise_error}
  it { expect{movieshow.right_year?(movieshow.year.to_i + 1, movieshow.year.to_i + 2)}.to raise_error}

  #it { expect(MovieToShow.create(ancient_record)).to be_an_instance_of AncientMovie}
  describe "#create" do
    include_examples "creates a movie of appropriate class", 1900, 1945, AncientMovie
  end

  #it { expect(MovieToShow.create(classic_record)).to be_an_instance_of ClassicMovie}

  #it { expect(MovieToShow.create(modern_record)).to be_an_instance_of ModernMovie}

  #it { expect(MovieToShow.create(new_record)).to be_an_instance_of NewMovie}

end
