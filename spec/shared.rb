RSpec.shared_examples "creates a collection of diff.movies" do |cinema|
  it{ expect(cinema).to be_an_instance_of Cinema }

  it{ expect(cinema.collection).to be_an_instance_of Array}

  it{ expect(cinema.collection).to all(be_an_instance_of(AncientMovie) | be_an_instance_of(ClassicMovie) | be_an_instance_of(ModernMovie) | be_an_instance_of(NewMovie))}
end

RSpec.shared_examples "a movie with limited period and certain price" do |year_range, expected_period, expected_price|
  let(:movies_file) { MoviePack::MOVIEFILE }
  let(:rec_headers) { MoviePack::REC_HEADERS }
  let(:record) do
    CSV.read(movies_file, col_sep: "|", headers: rec_headers)
       .map
       .find{ |a| year_range.include?(a[:year].to_i) }
  end
  let(:bad_record) do
    CSV.read(movies_file, col_sep: "|", headers: rec_headers)
    .map
    .find{ |a| !(year_range.include?(a[2].to_i)) }
  end
  let(:movie) { described_class.new(record) }

  it{ expect(movie).to be_an_instance_of described_class }

  describe "#initialize and #check_year" do 
    it { expect{described_class.new(bad_record)}.to raise_error(ArgumentError) }
  end 

  describe '#period' do
    it "returns appriopriate value" do
      expect(movie.period).to eq(expected_period)
    end
  end

  describe '#price' do
    it "returns right price" do
      expect(movie.price).to eq(expected_price)
    end
  end

end

RSpec.shared_examples "creates a movie of appropriate class" do |year_range, class_name|
  let(:record) do
    CSV.read(MoviePack::MOVIEFILE, col_sep: "|", headers: MoviePack::REC_HEADERS)
       .map
       .find{ |a| year_range.include?(a[:year].to_i) }
  end
  it { expect(described_class.create(record)).to be_an_instance_of class_name }
end

def make_movie(movie_class, host = nil)
  record = CSV.read(
                    MoviePack::MOVIEFILE, col_sep: "|",
                    headers: MoviePack::REC_HEADERS
                   )
              .map
              .find{ |a| movie_class::PERIOD.include?(a[:year].to_i) }

  movie_class.new(record, host)
end

RSpec::Matchers.define :include_in_attribute do |key, expected|
  match do |actual|
    if expected.is_a?(Range)
      expected.include?(actual.send(key))
    else
      actual.send(key).include?(expected)
    end
  end
end

RSpec::Matchers.define_negated_matcher :not_include_in_attribute, :include_in_attribute