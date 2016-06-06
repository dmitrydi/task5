require_relative '../movie_classes'
require_relative '../netfix'
require 'csv'
require 'date'

describe MovieToShow do

  let(:record) {CSV.read('../movies.txt', col_sep: '|')[0]}
  let(:ancient_record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[2].to_i.between?(1900,1945)}}
  let(:classic_record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[2].to_i.between?(1946,1968)}}
  let(:modern_record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[2].to_i.between?(1969,2000)}}
  let(:new_record) {CSV.read("movies.txt", col_sep: "|").map.find{|a| a[2].to_i.between?(2001, Date.today.year)}}
  let(:movieshow) {MovieToShow.new(record)}

  it 'should have attributes like Movie plus :period' do
    expect(movieshow).to have_attributes(:genre => a_value, :period => a_value)
  end

  it 'should determine period well' do
    a_period = case movieshow.year.to_i

              when 1900..1945
                'ancient'
              when 1946..1968
                'classic'
              when 1969..2000
                'modern'
              when 2000..Date.today.year
                'new'
              else
                nil
              end
    expect(movieshow).to have_attributes(:period =>  a_period)
  end

  it 'should have :price attribute' do
    expect(movieshow).to have_attributes(:price => a_value)
  end

  it 'should set :price correctly' do
    a_price = case movieshow.period
                when 'acnient'
                  1
                when 'classic'
                  1.5
                when 'modern'
                  3
                when 'new'
                  5
                else
                  nil
              end
    expect(movieshow.price).to eq(a_price)
  end

  it { expect(MovieToShow.create(ancient_record)).to be_an_instance_of AncientMovie}

  it { expect(MovieToShow.create(classic_record)).to be_an_instance_of ClassicMovie}

  it { expect(MovieToShow.create(modern_record)).to be_an_instance_of ModernMovie}

  it { expect(MovieToShow.create(new_record)).to be_an_instance_of NewMovie}

end
