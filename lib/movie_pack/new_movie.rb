require_relative 'movie_classes'
require 'date'

module MoviePack

  class NewMovie < MovieToShow
    PERIOD = 2001..Date.today.year
    PRICE = 5

    def to_s
      years_ago = Date.today.year - @year
      "#{@title} - new film, released #{years_ago} years ago!"
    end
  end

end