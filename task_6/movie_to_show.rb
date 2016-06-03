require_relative 'movie'
require 'date'

class MovieToShow < Movie
  def initialize(record, host = nil)
    super(record, host)
    @period = case @year
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
  end
  attr_reader :period
end
