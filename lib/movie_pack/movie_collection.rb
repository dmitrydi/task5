require 'csv'
require_relative 'movie'

module MoviePack

class MovieCollection

  include Enumerable

  def initialize(movie_array = nil)
    @collection = movie_array
  end

  attr_reader :collection

  def create_movie(record, host = nil)
    Movie.new(record, host)
  end

  def read(filename = MoviePack::MOVIEFILE)
	  @collection = CSV.read(filename, col_sep: "|").map {|a| create_movie(a, self)}
    self
  end

  def self.read(filename = MoviePack::MOVIEFILE)
    new.read(filename)
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
   @movs_by_producers ||= @collection.group_by {|a| a.producer}.map{|key, val| [key,val.map {|a| a.title}]}.to_h
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

  def filter(filt = {}, filter_store = {})
    return self if filt.empty?
    filtered_collection = filt.inject(@collection) do |memo, (k,v)|
      block = filter_store[k] || proc { |v, m, k| m.match?(k, v) }
      memo.select{ |m| if block.arity.abs == 1 
                         block.call(m) 
                       else 
                         block.call(v, m, k)
                       end 
                  }
    end
    raise ArgumentError, "No movies found with filter #{filt}" if filtered_collection.empty?
    self.class.new(filtered_collection)
  end

  def stats(key)
    @collection.group_by {|a| a.send(key)}.map{|key, val| [key,val.count]}.to_h
  end

  def each(&block)
    @collection.each(&block)
  end
end

end