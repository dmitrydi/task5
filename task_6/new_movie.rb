require_relative 'movie_classes'
require 'date'

class NewMovie < MovieToShow
  def initialize(record, host = nil)
    super(record, host)
    self.right_year?(2001, Date.today.year)
    @period = 'new'
    @price = 5
  end

  attr_reader :period, :price

  def to_s
    years_ago = Date.today.year - @year.to_i
    "#{@title} - new film, released #{years_ago} years ago!"
  end
end