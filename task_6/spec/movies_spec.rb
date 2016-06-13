require_relative '..\movie_classes'
require 'date'
require 'csv'
require 'rspec/expectations'

RSpec::Matchers.define :raise_error_whith_bad_years do |min_year, max_year|
  match do |movie_class|
    bad_record = CSV.read("movies.txt", col_sep: "|").map.find{|a| a[2].to_i.between?(min_year, max_year)}
    movie_class.new(bad_record).should raise_error(ArgumentError) 

  end
end

describe AncientMovie do
  it { is_expected.to raise_error_with_bad_years(1946, 1968)}
end

