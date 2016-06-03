require_relative '../netfix'
require_relative '../movie'
require_relative '../movie_collection'
require_relative '../movie_to_show'


describe Netfix do
  before :each do
    @netfix = Netfix.read
  end

  describe 'new' do
    it 'may be initialized with no parameters' do
      expect(@netfix).to be_an_instance_of Netfix
    end
  end

  describe '#read' do
    it 'may initialize @collection' do
      netfix = Netfix.read
      expect(netfix.collection).to be_an_instance_of Array
    end

    it 'creates an array of instances of MovieToShow' do
      expect(Netfix.read.collection.first).to be_an_instance_of MovieToShow
    end

    it 'insures @collection items to have :period attribute' do
      expect(Netfix.read.collection.first.period).not_to be_nil
    end


  end

  describe '#filter' do
    it 'should return an instance of MovieCollection' do
      expect(@netfix.filter(period: 'classic')).to be_an_instance_of MovieCollection
    end

    it 'should fill in @collection attribute' do
      expect(@netfix.filter(period: 'classic').collection).to be_an_instance_of Array
    end

    it 'should ensure @collection is not empty' do
      expect(@netfix.filter(period: 'classic').collection).not_to be_empty
    end
  end

  describe '#pay' do
    it 'should be a method of Netfix instance' do
      expect(@netfix).to respond_to(:pay).with(1).argument
    end
  end


  describe '#show' do
    it 'may take one argument' do
      expect(@netfix).to respond_to(:show).with(1).argument
    end

    it 'may take no arguments' do
      expect(@netfix).to respond_to(:show).with(0).argument
    end

    #it 'should print different messages for different periods' do
    #  expect(@netfix.show(period: 'ancient')).to include("ancient movie")
    #  expect(@netfix.show(period: 'classic')).to include("classic movie, producer")
    #  expect(@netfix.show(period: 'modern')).to include("contemporary movie, starring")
    #  expect(@netfix.show(period: 'new')).to include("new movie")
    #end

  end


end