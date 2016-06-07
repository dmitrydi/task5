require_relative 'movie_classes'

class ClassicMovie < MovieToShow
  def initialize(record, host = nil)
    super(record, host)
    self.right_year?(1946, 1968)
    @period = 'classic'
    @price = 1.5
  end

  attr_reader :period, :price

  def to_s
    list_of_movies = (@host? @host.films_by_producers[@producer].join(", ") : "really good one")
    "#{@title} - classic movie, producer: #{@producer} (#{list_of_movies})"
  end
end