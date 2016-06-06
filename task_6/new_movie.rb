require_relative 'movie_to_show'
require 'date'

class NewMovie < MovieToShow
  def initialize(record, host = nil)
    super(record, host)
    if !@year.to_i.between?(2001, Date.today.year)
      raise ArgumentError, "year should be in range 2001..#{Date.today.year}"
    end
  end

  def to_s
    years_ago = Date.today.year - @year.to_i
    "#{@title} - new film, released #{years_ago} years ago!"
  end
end