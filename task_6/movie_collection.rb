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

  def self.read(filename = "movies.txt")
    self.new.read(filename)
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

  def films_by_producers
    @movs_by_producers ? @movs_by_producers : @movs_by_producers = @collection.group_by {|a| a.producer}.map{|key, val| [key,val.map {|a| a.title}]}.to_h
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

  def filter(filt = nil)
    unless filt
      self
    else
      filtered_collection = @collection.find_all {
	      |a|
	      filt.inject(true) {|memo, (key, val)| memo && a.match?(key, val)}
      }
	    if filtered_collection.length == 0 
        raise ArgumentError, 'no movies found with the filter given'
      else
        self.class.new(filtered_collection)
      end
    end
  end

  def stats(key)
    @collection.group_by {|a| a.send(key)}.map{|key, val| [key,val.count]}.to_h
  end


end