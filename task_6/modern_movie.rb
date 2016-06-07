require_relative 'movie_classes'

class ModernMovie < MovieToShow
  def initialize(record, host = nil)
    super(record, host)
    self.right_year?(1969, 2000)
    @period = 'modern'
    @price = 3
  end

  attr_reader :period, :price

  def to_s
    "#{@title} - modern movie, starring: #{@actors.join(', ')}"
  end
end