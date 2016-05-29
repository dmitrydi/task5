class MovieCollection
 require 'csv'
 require_relative 'movie.rb'

 def initialize(parsedlist = nil)
  if parsedlist == nil
   @collection
  else
   @collection = parsedlist
  end
 end

 def read(filename = "movies.txt")
  self.collection = CSV.read(filename, col_sep: "|").map {|a| Movie.new(a, self)}
  self
 end

 attr_accessor :collection

 def to_s
  @collection
 end

 def first(n = nil)
  if n == nil 
   @collection[0]
  else
   dum = MovieCollection.new
   dum.collection = @collection.first(n)
   dum
  end
 end

 def [] (n)
  dum = MovieCollection.new
  dum.collection = @collection[n]
  dum
 end

 def all
  @collection
 end

 def sort_by(key)
  dum = MovieCollection.new
  dum.collection = @collection.sort_by {|a| a.send(key)}
  dum
 end

 def filter(filt)
  dum = MovieCollection.new
  dum.collection = @collection.find_all {
    |a|
    flag = true 
    filt.each {|key, val| flag &= (a.send(key).include?(val))}
    flag
  }
  dum
 end

 def stats(key)
  uvals = @collection.each.map {|a| a.send(key)}.flatten.uniq
  nstat = uvals.each.map {|val| @collection.count {|b| b.send(key).include?(val)}}
  Hash[uvals.zip(nstat)]
 end
end