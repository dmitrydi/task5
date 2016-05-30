require 'csv'
require_relative 'movie'

class MovieCollection

  def initialize(movie_array = nil)
    @collection = movie_array
  end

  attr_reader :collection

  def read(filename = "movies.txt")
	  @collection = CSV.read(filename, col_sep: "|").map {|a| Movie.new(a, self)}
	  self
  end

  def existing_genres
    @existing_genres = @collection.each.map {|a| a.genre}.flatten.uniq
  end

  def genre_exists?(genre)
    existing_genres if !@existing_genres
    @existing_genres.include?(genre)
  end

  def to_s
    @collection.join("\n")
  end

  def first(n = nil)
	  if n
      MovieCollection.new(@collection.first(n))
	  else
	    @collection[0]
	  end
  end

  def [] (n)
	  MovieCollection.new([@collection[n]])
  end

  alias :all :collection  

  def sort_by(key)
	  MovieCollection.new(@collection.sort_by {|a| a.send(key)})
  end

  def filter(filt)
	  MovieCollection.new(@collection.find_all {
	    |a|
	    filt.inject(true) {|memo, (key, val)| memo && (a.send(key).include?(val)) }
	    }
	  )
  end

  def stats(key)
    @collection.group_by {|a| a.send(key)}.map{|key, val| [key,val.count]}.to_h
  end
end