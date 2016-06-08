require_relative 'movie_classes'
require 'date'

class MovieToShow < Movie
  def initialize(record, host = nil)
    super(record, host)
  end

  PERIOD = nil

  def check_year(year)
    if self.class::PERIOD && !(self.class::PERIOD.include?(@year.to_i))
      raise ArgumentError, "year should be in range #{PERIOD}"
    end
  end

  def self.create(record, host = nil)
    case record[2].to_i
      when AncientMovie::PERIOD
        AncientMovie.new(record, host)
      when ClassicMovie::PERIOD
        ClassicMovie.new(record, host)
      when ModernMovie::PERIOD
        ModernMovie.new(record, host)
      when NewMovie::PERIOD
        NewMovie.new(record, host)
      else
        raise ArgumentError, "Error in MovieToShow#create: unrecognized value of year"
    end
  end

end
