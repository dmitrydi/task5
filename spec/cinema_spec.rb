require_relative '..\lib\cinema'
require_relative '..\lib\movie_classes'
require_relative 'cinema_shared_spec'


describe Cinema do

  let(:cinema) {Cinema.read}

  describe '#read' do
    include_examples "creates a collection of diff.movies", Cinema.new.read
  end

  subject{cinema}

  describe '#self.read' do
    it { is_expected.to be_instance_of Cinema }
  end

  describe '#inspect' do
    subject {cinema.inspect}
    it { is_expected.to be_instance_of String }
    it { is_expected.to include("ancient", "classic", "new", "modern")}
  end

end