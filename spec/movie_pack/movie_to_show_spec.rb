require_relative 'spec_helper'

describe MovieToShow do

  let(:record) {CSV.read(MoviePack::MOVIEFILE, col_sep: '|')[0]}

  it { expect{MovieToShow.new(record)}.to raise_error }

  describe '#create' do

    context 'when AncientMovie required' do
      include_examples "creates a movie of appropriate class", AncientMovie::PERIOD, AncientMovie 
    end

    context 'when ClassicMovie required' do
     include_examples "creates a movie of appropriate class", ClassicMovie::PERIOD, ClassicMovie
    end

    context 'when ModernMovie required' do
     include_examples "creates a movie of appropriate class", ModernMovie::PERIOD, ModernMovie
    end 

    context 'when NewMovie required' do
     include_examples "creates a movie of appropriate class", NewMovie::PERIOD, NewMovie
    end   

  end

end
