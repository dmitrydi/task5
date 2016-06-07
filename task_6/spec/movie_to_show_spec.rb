require_relative '../movie_classes'
require_relative '../netfix'
require_relative 'movies_shared_spec'
require 'csv'
require 'date'

describe MovieToShow do

  describe "right_year?" do
    let(:record) {CSV.read('..\movies.txt', col_sep: "|")[0]}
    let(:movie_to_show) {MovieToShow.new(record)}
    let(:year) {movie_to_show.year.to_i}

    it "returns nil when @year in specified range" do
      expect(movie_to_show.right_year?(year-1, year+1)).to be_nil
    end

    it "raise an ArgumentError when @year is out of specified range" do
      expect{ movie_to_show.right_year?(year-2, year-1) }.to raise_error(ArgumentError, "year should be in range #{year-2}..#{year-1}")
    end
  end

  describe "#create" do

    context "for 1900..1945 creates AncientMovie" do
      include_examples "creates a movie of appropriate class", 1900, 1945, AncientMovie
    end

    context "for 1946..1968 creates ClassicMovie" do
      include_examples "creates a movie of appropriate class", 1946, 1968, ClassicMovie
    end

    context "for 1969..2000 creates ModernMovie" do
      include_examples "creates a movie of appropriate class", 1969, 2000, ModernMovie
    end

    context "for 2001..2016 creates ModernMovie" do
      include_examples "creates a movie of appropriate class", 2001, 2016, NewMovie
    end

    context "for bad year value raises an ArgumentError" do
      let(:bad_record) {CSV.read('..\movies.txt', col_sep: "|")[0]} 

      it "expect ot raise error for year value > 2016" do
        bad_record[2] = "2017" 
        expect{MovieToShow.create(bad_record)}.to raise_error(ArgumentError, "Error in MovieToShow#create: unrecognized value of year")
      end

      it "expect ot raise error for year value < 1900" do
        bad_record[2] = "1800" 
        expect{MovieToShow.create(bad_record)}.to raise_error(ArgumentError, "Error in MovieToShow#create: unrecognized value of year")
      end

      it "expect ot raise error for if year value is missing" do
        bad_record[2] = "" 
        expect{MovieToShow.create(bad_record)}.to raise_error(ArgumentError, "Error in MovieToShow#create: unrecognized value of year") 
      end
    end


  end

end
