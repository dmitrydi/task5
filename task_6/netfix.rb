require_relative 'movie'
require_relative 'movie_collection'

class Netfix < MovieCollection
  def initialize(movie_array = nil)
    super(movie_array)
    @@money = 0
  end

  attr_reader :collection

  def read(filename = "movies.txt")
    @collection = CSV.read(filename, col_sep: "|").map {|a| MovieToShow.new(a, self)}
    self
  end

  def self.read(filename = "movies.txt")
    Netfix.new.read(filename)
  end

  def pay(amount)
    @@money += amount
  end

  def show(filter = nil)
    
  end

end