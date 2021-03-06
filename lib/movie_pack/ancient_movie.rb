require_relative 'movie_classes'

module MoviePack
  # class describing movies produced in PERIOD
  class AncientMovie < MovieToShow
    PERIOD = 1900..1945
    PRICE = 1

    def to_s
      "#{title} - old movie (#{year})"
    end
  end
end
