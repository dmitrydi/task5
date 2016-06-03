require_relative '../movie'
require_relative '../movie_to_show'
require 'csv'

describe MovieToShow do
  before :each do
    record = CSV.read('../movies.txt', col_sep: '|')[0]
    @movieshow = MovieToShow.new(record)
  end

  it 'should have attributes like Movie plus :period' do
    expect(@movieshow).to have_attributes(:genre => a_value, :period => a_value)
  end

  it 'should determine period well' do
    a_period = case @year
              when 1900..1945
                'ancient'
              when 1946..1968
                'classic'
              when 1969..2000
                'modern'
              when 2000..2016
                'new'
              else
                nil
              end
    expect(@movieshow).to have_attributes(:period => a_period)
  end

end
