require_relative '../movie'
require_relative '../movie_to_show'
require 'csv'
require 'date'

describe MovieToShow do
  before :each do
    record = CSV.read('../movies.txt', col_sep: '|')[0]
    @movieshow = MovieToShow.new(record)
  end

  it 'should have attributes like Movie plus :period' do
    expect(@movieshow).to have_attributes(:genre => a_value, :period => a_value)
  end

  it 'should determine period well' do
    a_period = case @movieshow.year.to_i

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
    expect(@movieshow).to have_attributes(:period =>  a_period)
  end

  it 'should have :price attribute' do
    expect(@movieshow).to have_attributes(:price => a_value)
  end

  it 'should set :price correctly' do
    a_price = case @movieshow.period
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
    expect(@movieshow.price).to eq(a_price)
  end

  describe '#to_s' do
    it 'should return a String' do
      expect(@movieshow.to_s).to be_an_instance_of String
    end

    it 'should put correct messages for diff. periods' do
      str_to_compare = case @movieshow.period
                       when 'ancient'
                        "#{@movieshow.title} - old movie (#{@movieshow.year})"
                       when 'classic'
                        "#{@movieshow.title} - classic movie, producer: #{@movieshow.producer}"
                       when 'modern'
                        "#{@movieshow.title} - modern movie, starring: #{@movieshow.actors.join(', ')}"
                       when 'new'
                        "#{@movieshow.title} - new film, released #{Date.today.year - @movieshow.year} years ago!"
                      end
      expect(@movieshow.to_s).to eq(str_to_compare)
    end
  end
end
