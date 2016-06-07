require_relative 'movie_classes'

class AncientMovie < MovieToShow
  def initialize(record, host = nil)
    super(record, host)
    self.right_year?(1900, 1945)
    @period = 'ancient'
    @price = 1
  end

  attr_reader :period, :price

  def to_s
    "#{@title} - old movie (#{@year})"
  end
end
