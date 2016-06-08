require_relative 'movie_classes'
require 'date'

class MovieToShow < Movie
  PERIOD = nil
  PRICE = nil

  def initialize(record, host = nil)
    super
    check_year(@year)
  end

  def price
    self.class::PRICE
  end

  def period
    klass = self.class
    (klass.to_s.downcase.sub("movie","")) if klass::PERIOD
  end


  def check_year(year)
    period = self.class::PERIOD
    if period && !(period.include?(@year.to_i))
      raise ArgumentError, "year should be in range #{period}"
    end
  end

  def self.create(record, host = nil)
    klass = [AncientMovie, ClassicMovie, ModernMovie, NewMovie].detect {|klass| klass::PERIOD.include?(record[2].to_i)} or
            raise(ArgumentError, "Error in MovieToShow#create: unrecognized value of year")
    klass.new(record, host)
  end

end
