require_relative 'movie_pack/movie'
require_relative 'movie_pack/movie_collection'
require_relative 'movie_pack/ancient_movie'
require_relative 'movie_pack/cash_desk'
require_relative 'movie_pack/cinema'
require_relative 'movie_pack/classic_movie'
require_relative 'movie_pack/modern_movie'
require_relative 'movie_pack/movie_classes'
require_relative 'movie_pack/movie_to_show'
require_relative 'movie_pack/netfix'
require_relative 'movie_pack/new_movie'
require_relative 'movie_pack/theatre'

module MoviePack
  MOVIEFILE = File.expand_path('../../data/movie_pack/movies.txt', __FILE__)

  class EncashmentError < StandardError
  end
end