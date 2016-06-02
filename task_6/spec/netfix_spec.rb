require_relative '../netfix'
require_relative '../movie'
require_relative '../movie_collection'


describe Netfix do
  before :each do
    @netfix = Netfix.new
  end

  describe 'new' do
    it 'may be initialized with no parameters' do
      expect(@netfix).to be_an_instance_of Netfix
    end
  end

  describe 'read' do
    it 'may be initialized with read' do
      netfix = Netfix.read
      expect(netfix.collection).to be_an_instance_of Array
    end
  end

end
