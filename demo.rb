require_relative 'movie.rb'
require_relative 'movie_collection.rb'

movies = MovieCollection.new.read
puts movies.all.first(3)
puts movies.all.first.actors
puts movies.sort_by(:date).first(10).to_s
puts movies.filter(genre: 'Comedy').to_s
puts movies.stats(:month)
begin
 puts movies.all.first.has_genre?('Tragedy')
rescue ArgumentError => err
 puts(err.message)
end