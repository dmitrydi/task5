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

    it 'should change @money value' do
      netfix = Netfix.read
      expect(netfix.money).to eq(0)
      netfix.pay(10)
      expect(netfix.money).to eq(10)
      netfix.pay(10)
      expect(netfix.money).to eq(20)
    end
  end

  describe '#films by producers' do
    it 'shuold return a hash of films grouped by producers' do
      expect(@netfix.films_by_producers).to be_an_instance_of Hash
    end

    it 'is expected that hash in not empty' do
      expect(@netfix.films_by_producers).not_to be_empty
    end
  end

  describe '#make_shortlist' do

    it 'returns an array of MovieToShow instances' do
      @netfix.pay(10)
      expect(@netfix.make_shortlist(period: 'classic')[0]).to be_an_instance_of MovieToShow
      expect(@netfix.make_shortlist[0]).to be_an_instance_of MovieToShow
    end

    it 'returns empty array for bad filter' do
      @netfix.pay(10)
      expect{@netfix.make_shortlist(genre: 'Tragedy')}.to raise_error(ArgumentError)
    end

    it 'raises an error when no money' do
      netfix = Netfix.read
      expect{netfix.make_shortlist(period: 'classic')}.to raise_error(RuntimeError, "you don't have enough money")
    end

    it 'returns an array of MovieToShow instances when paid' do
      netfix = Netfix.read
      expect(netfix.make_shortlist(period: 'classic')).to be_empty
      netfix.pay(10)
      expect(netfix.make_shortlist(period: 'classic')).to be_an_instance_of Array
    end

  end



  describe '#show' do
    it 'may take one argument' do
      expect(@netfix).to respond_to(:show).with(1).argument
    end

    it 'may take no arguments' do
      expect(@netfix).to respond_to(:show).with(0).argument
    end

    it 'is expected to raise error when no films found' do
      expect{@netfix.show(genre: 'Tragedy')}.to raise_error(ArgumentError, "no films found with given parameters")
      expect{@netfix.show(genre: 'Comedy')}.not_to raise_error(ArgumentError)
    end

    it 'is expected to raise error with no money' do
      expect{@netfix.show(period: 'classic')}.to raise_error(RuntimeError, "you don't have enough money")
    end

    it 'is expected not to raise error when enough money' do
      @netfix.pay(10)
      expect{@netfix.show(period: 'classic')}.not_to raise_error(RuntimeError, "you don't have enough money")
    end

    it 'is expected to return a string when OK' do
      @netfix.pay(10)
      expect(@netfix.show(period: 'classic')).to be_an_instance_of String
    end

    it 'is expected to work well when no filters given' do
      @netfix.pay(10)
      expect(@netfix.show).to be_an_instance_of String
    end

    it 'is expected to charge money for showing' do
      @netfix.pay(10)
      @netfix.show(period: 'new')
      expect(@netfix.money).to eq(5)
    end

  end

end