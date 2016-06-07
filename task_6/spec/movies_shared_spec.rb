require_relative '..\movie_classes'
require 'csv'

RSpec.shared_examples "a movie with limited period and certain price" do |start_year, end_year, expected_period, expected_price|
  let(:record) {CSV.read('..\movies.txt', col_sep: "|").map.find{|a| a[2].to_i.between?(start_year, end_year)}}
  let(:bad_record) {CSV.read('..\movies.txt', col_sep: "|").map.find{|a| (a[2].to_i > end_year || a[2].to_i < start_year)}}
  let(:movie) {described_class.new(record)}

  it{ expect(record[2].to_i).to be_between(start_year, end_year).inclusive }
  it{ expect(bad_record[2].to_i).not_to be_between(start_year, end_year).inclusive }

  it{ expect{described_class.new(bad_record)}.to raise_error(ArgumentError) }

  subject {movie}

  it{ is_expected.to be_an_instance_of described_class }
  it{ is_expected.to have_attributes(:period => expected_period, :price => expected_price)}
end

RSpec.shared_examples "prepare an instance" do |start_year, end_year, instance_ref|
  let(:record) {CSV.read('..\movies.txt', col_sep: "|").map.find{|a| a[2].to_i.between?(start_year, end_year)}}
  it{ expect(record[2].to_i).to be_between(start_year, end_year).inclusive }
  let(instance_ref) {described_class.new(record)}
end

RSpec.shared_examples "creates a movie of appropriate class" do |start_year, end_year, class_name|
  let(:record) {CSV.read("../movies.txt", col_sep: "|").map.find{|a| a[2].to_i.between?(start_year, end_year)}}
  it { expect(described_class.create(record)).to be_an_instance_of class_name }
end


