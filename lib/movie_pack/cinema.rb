require_relative 'movie_classes'

module MoviePack
  # utitlity class - parent for Netfix and Theatre
  class Cinema < MovieCollection
    def create_movie(record, host = nil)
      MovieToShow.create(record, host)
    end

    def inspect
      stats(:period).collect { |k, v| "#{k} - #{v}" }.join(', ')
    end
  end
end
