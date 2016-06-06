require_relative 'movie_to_show'

class AncientMovie < MovieToShow
  def initialize(record, host = nil)
    super(record, host)
    if !@year.to_i.between?(1900,1945)
      raise ArgumentError, "year should be in range 1900..1945"
    end
  end

  def to_s
    "#{@title} - old movie (#{@year})"
  end
end
