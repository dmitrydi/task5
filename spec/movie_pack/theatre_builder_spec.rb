require_relative 'spec_helper'

describe TheatreBuilder do
  let(:hall_block) { proc { hall :red, title: 'Red Hall', places: 100 } }

  let(:period_block) do
    Proc.new do
      period '09:00'..'11:00' do
        description 'Morning'
        filters genre: 'Comedy', year: 1900..1950
        price 10
        hall :red, :blue
      end
    end
  end
  let(:block) do
    Proc.new do
      hall :red, title: 'Red Hall', places: 100

      period '09:00'..'11:00' do
        description 'Morning'
        filters genre: 'Comedy', year: 1900..1950
        price 10
        hall :red, :blue
      end
    end
  end

  let(:theatre) { Theatre.new {} }
  let(:no_block_theatre) { Theatre.new }

  describe '#initialize' do
    it { expect { TheatreBuilder.new(theatre, &hall_block) }.to change{ theatre.halls.length }.from(0).to(1) }
    it { expect { TheatreBuilder.new(theatre, &period_block) }.to change{ theatre.periods.length }.from(0).to(1) }
    it { expect { TheatreBuilder.new(no_block_theatre, &block) }.to raise_error(RuntimeError) }
    it { expect(TheatreBuilder.new(no_block_theatre).host).to be_instance_of(Theatre) }
  end

  let(:tb) { TheatreBuilder.new(theatre) }  

  describe '#hall' do
    it { expect { tb.hall(:new_hall, title: 'New Hall', places: 10) }.to change { theatre.halls.length }.from(0).to(1) }

    context 'it sets attributes of @host.halls' do
      before(:example) do
        tb.hall(:new_hall, title: 'New Hall', places: 10)
      end
      it { expect(theatre.halls.first).to have_attributes(:name => :new_hall, :title => 'New Hall', :places => 10) }
    end
  end

  describe '#period' do
    let(:description_block) do
      Proc.new do
        description 'Morning'
        filters genre: 'Comedy', year: 1900..1950
        price 10
        hall :red, :blue
      end
    end
    it { expect { tb.period('09:00'..'11:00', &description_block) }.to change { theatre.periods.length }.from(0).to(1) }

    context 'it sets attributes of @host.periods' do
      before(:example) do
        tb.period('09:00'..'11:00', &description_block)
      end

      it do
        expect(theatre.periods.first)
        .to have_attributes(
                            :interv => '09:00'..'11:00',
                            :description => 'Morning',
                            :filters => { genre: 'Comedy', year: 1900..1950 },
                            :price => 10,
                            :hall => [:red, :blue]
                            )
      end
    end
  end

  describe TheatreBuilder::Period do
    let(:period) { TheatreBuilder::Period.new('09:00'..'11:00') }

    let(:description_block) do
      Proc.new do
        description 'Morning'
        filters genre: 'Comedy', year: 1900..1950
        price 10
        hall :red, :blue
      end
    end

    let(:period_with_block) { TheatreBuilder::Period.new('09:00'..'11:00', &description_block) }

    it do 
      expect(period)
      .to have_attributes(
                          :interv => '09:00'..'11:00',
                          :description => MoviePack::Theatre::DEFAULT_DESCRIPTION,
                          :filters => {},
                          :price => MoviePack::Theatre::DEFAULT_PRICE,
                          :hall => MoviePack::Theatre::DEFAULT_HALL
                          )
    end

    it do 
      expect(period_with_block)
      .to have_attributes(
                          :interv => '09:00'..'11:00',
                          :description => 'Morning',
                          :filters => { genre: 'Comedy', year: 1900..1950 },
                          :price => 10,
                          :hall => [:red, :blue]
                          )
    end

    describe '#description' do
      it { expect(period_with_block.description).to eq('Morning') }
      it { expect { period.description('Morning') }.to change{ period.description }.to('Morning') }
    end

    describe '#filters' do
      it { expect(period_with_block.filters).to eq( { genre: 'Comedy', year: 1900..1950 } ) }
      it { expect { period.filters( { genre: 'Comedy' } ) }.to change{ period.filters }.from( {} ).to( { genre: 'Comedy' } ) }
    end

    describe '#price' do
      it { expect { period.price(100) }.to change { period.price }.to(100) }
    end

    describe '#hall' do
      it { expect { period.hall(:red) }.to change { period.hall }.to([:red]) }
    end

    describe '#shown_at?' do
      it { expect(period_with_block.shown_at?(:red)).to be true }
      it { expect(period_with_block.shown_at?(:blue)).to be true }
      it { expect(period_with_block.shown_at?(:green)).to be false }
    end
  end
end