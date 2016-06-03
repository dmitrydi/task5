require_relative '../netfix'
require_relative '../movie'
require_relative '../movie_collection'


describe Netfix do
  before :each do
    @netfix = Netfix.read
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

  describe 'show' do
    it 'should take a list of filters as a parameter' do
      expect{@netfix.show(period: 'classic', genre: 'comedy')}.to output.to_stdout
    end

    it 'may take one argument' do
      expect(@netfix).to respond_to(:show).with(1).argument
    end

    it 'may take no arguments' do
      expect(@netfix).to respond_to(:show).with(0).argument
    end

    it 'should print different messages for different periods' do
      expect(@netfix.show(period: 'ancient')).to include("ancient movie")
      expect(@netfix.show(period: 'classic')).to include("classic movie, producer")
      expect(@netfix.show(period: 'modern')).to include("contemporary movie, starring")
      expect(@netfix.show(period: 'new')).to include("new movie")
    end
  end


end