require_relative 'movie_classes'

class Cinema < MovieCollection

  def create_movie(record, host = nil)
    MovieToShow.create(record, host)
  end

  def inspect
    stats(:period).collect{ |k, v| "#{k} - #{v}"}.join(", ")
  end

end
