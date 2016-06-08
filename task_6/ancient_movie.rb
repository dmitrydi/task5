require_relative 'movie_classes'

class AncientMovie < MovieToShow
  PERIOD = 1900..1945
  PRICE = 1

  def initialize(record, host = nil)
    super(record, host)
    self.check_year(@year)
  end

  def period
    'ancient'
  end

  def price
    PRICE
  end

  def to_s
    "#{@title} - old movie (#{@year})"
  end
end
