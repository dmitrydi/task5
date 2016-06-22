require_relative 'movie_classes'

module MoviePack
  class ModernMovie < MovieToShow
    PERIOD = 1969..2000
    PRICE = 3

    def to_s
      "#{@title} - modern movie, starring: #{@actors.join(', ')}"
    end
  end
end