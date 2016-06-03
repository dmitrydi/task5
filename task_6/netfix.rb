require_relative 'movie'
require_relative 'movie_collection'

class Netfix < MovieCollection
  def initialize(movie_array = nil)
    super(movie_array)
    @list_to_show
  end

  def self.read
    Netfix.new(MovieCollection.read.collection)
  end

  def show(filter = nil)
    @collection.to_s
  end

end