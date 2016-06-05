require_relative 'movie'
require 'date'

class MovieToShow < Movie
  def initialize(record, host = nil)
    super(record, host)

    @period = case @year.to_i
                when 1900..1945
                  'ancient'
                when 1946..1968
                  'classic'
                when 1969..2000
                  'modern'
                #when 2000..Date.today.year
                #  'new'
                else
                  'new'
              end

    @price = case @period
                when 'acnient'
                  1
                when 'classic'
                  1.5
                when 'modern'
                  3
                when 'new'
                  5
                else
                  1
              end 
  end

  attr_reader :period, :price

  def to_s
    case @period
      when 'ancient'
        "#{@title} - old movie (#{@year})"
      when 'classic'
        list_of_movies = (@host? @host.films_by_producers[@producer].join(", ") : "...")
        "#{@title} - classic movie, producer: #{@producer} (#{list_of_movies})"
      when 'modern'
        "#{@title} - modern movie, starring: #{@actors.join(', ')}"
      when 'new'
        years_ago = Date.today.year - @year.to_i
        "#{@title} - new film, released #{years_ago} years ago!"
      else
        raise RuntimeError, "Unable to classify movie #{title}"
    end
  end

end
