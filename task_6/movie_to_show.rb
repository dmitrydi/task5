require_relative 'movie_classes'
require 'date'

class MovieToShow < Movie
  def initialize(record, host = nil)
    super(record, host)
  end

  def right_year?(min_year, max_year)
    if !@year.to_i.between?(min_year, max_year)
      raise ArgumentError, "year should be in range #{min_year}..#{max_year}"
    end
  end

  def self.create(record, host = nil)
    case record[2].to_i
      when 1900..1945
        AncientMovie.new(record, host)
      when 1946..1968
        ClassicMovie.new(record, host)
      when 1969..2000
        ModernMovie.new(record, host)
      when 2001..Date.today.year
        NewMovie.new(record, host)
      else
        raise ArgumentError, "Error in MovieToShow#create: unrecognized value of year"
    end
  end

end
