require 'rspec/expectations'
require_relative '../movie_classes'
require 'csv'

RSpec::Matchers.define :raise_error_with_period do |min_year, max_year|
  macth do |movie_class|
    bad_record = CSV.read("../movies.txt", col_sep: "|").map.find{|a| a[2].to_i.between?(min_year, max_year)}
    it { expect{movie_class.new(bad_record)}.to raise_error(ArgumentError)}
  end
end

RSpec.describe ClassicMovie do

  it {is_expected.to raise_error_with_period(1969, 2000)}

end
