require_relative 'movie_classes'

class ClassicMovie < MovieToShow
  PERIOD = 1946..1968
  PRICE = 1.5

  def to_s
    list_of_movies = (@host? @host.films_by_producers[@producer].join(", ") : "really good one")
    "#{@title} - classic movie, producer: #{@producer} (#{list_of_movies})"
  end
end