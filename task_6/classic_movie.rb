require_relative 'movie_to_show'

class ClassicMovie < MovieToShow
  def initialize(record, host = nil)
    super(record, host)
    if !@year.to_i.between?(1946,1968)
      raise ArgumentError, "year should be in range 1946..1968"
    end
  end

  def to_s
    list_of_movies = (@host? @host.films_by_producers[@producer].join(", ") : "...")
    "#{@title} - classic movie, producer: #{@producer} (#{list_of_movies})"
  end
end