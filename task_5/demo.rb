require_relative 'movie'
require_relative 'movie_collection'
require 'csv'

movies = MovieCollection.read
puts movies.all.first(1)
puts
puts movies.all.first.actors
puts
puts movies.sort_by(:country).first(10).to_s
puts
puts movies.filter(genre: 'Comedy', country: 'USA').to_s
puts
puts movies.stats(:month)
puts
begin
  puts movies.all.first.has_genre?('Tragedy')
rescue ArgumentError => err
  puts(err.message)
end
record = CSV.read("movies.txt", col_sep: "|")[0] 
mov = Movie.new(record)
puts mov.has_genre?('Comedy')
puts movies[1].stats(:month)
