require 'csv'
require_relative 'movie'

class MovieCollection

  def initialize(movie_array = nil)
	  if movie_array != nil
	    @collection = movie_array
	  end
  end

  attr_reader :collection

  def read(filename = "movies.txt")
	  @collection = CSV.read(filename, col_sep: "|").map {|a| Movie.new(a, self)}
	  self
  end

  def genre_exists?(genre)
	  @collection.each.map {|a| a.genre}.flatten.uniq.include?(genre)
  end

  alias :to_s :collection

  def first(n = nil)
	  if n == nil 
	    @collection[0]
	  else
	    MovieCollection.new(@collection.first(n))
	  end
  end

  def [] (n)
	  MovieCollection.new(@collection[n])
  end

  alias :all :collection  

  def sort_by(key)
	  MovieCollection.new(@collection.sort_by {|a| a.send(key)})
  end

  def filter(filt)
	  MovieCollection.new(@collection.find_all {
	    |a|
	    filt.inject(true) {|memo, ary| memo && a.send(ary[0]).include?(ary[1]) }
	    }
	  )
  end

  def stats(key)
	  uvals = @collection.each.map {|a| a.send(key)}.flatten.uniq
	  nstat = uvals.each.map {|val| @collection.count {|b| b.send(key).include?(val)}}
	  Hash[uvals.zip(nstat)]
  end
end