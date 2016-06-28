require_relative 'movie_classes'

module MoviePack
  # class describing movies produces in PERIOD
  class ClassicMovie < MovieToShow
    PERIOD = 1946..1968
    PRICE = 1.5

    def to_s
      list_of_movies = if @host
                         @host.films_by_producers[@producer].join(', ')
                       else
                         'really good one'
                       end
      "#{@title} - classic movie, producer: #{@producer} (#{list_of_movies})"
    end
  end
end
