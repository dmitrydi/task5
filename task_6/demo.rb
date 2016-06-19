require_relative 'movie'
require_relative 'movie_collection'
require 'csv'

movies = MovieCollection.read
puts movies.filter(actors: 'Sharon Stone').to_s
puts

