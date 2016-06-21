require_relative 'movie_classes'
require 'date'

class MovieToShow < Movie

  def initialize(record, host = nil)
    super
    check_year(@year)
  end

  def price
    self.class::PRICE
  end

  def period
    self.class.to_s.downcase.sub("movie","")
  end

private
  def check_year(year)
    raise ArgumentError, "year should be in range #{period}" if !(self.class::PERIOD.include?(@year.to_i))
  end

  def self.create(record, host = nil)
    klass = [AncientMovie, ClassicMovie, ModernMovie, NewMovie].detect {|klass| klass::PERIOD.include?(record[2].to_i)} or
            raise(ArgumentError, "Error in MovieToShow#create: unrecognized value of year")
    klass.new(record, host)
  end

end
