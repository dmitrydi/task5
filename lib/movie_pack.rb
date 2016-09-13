require_relative 'movie_pack/movie'
require_relative 'movie_pack/movie_collection'
require_relative 'movie_pack/ancient_movie'
require_relative 'movie_pack/cash_desk'
require_relative 'movie_pack/cinema'
require_relative 'movie_pack/classic_movie'
require_relative 'movie_pack/modern_movie'
require_relative 'movie_pack/movie_classes'
require_relative 'movie_pack/movie_to_show'
require_relative 'movie_pack/netflix'
require_relative 'movie_pack/new_movie'
require_relative 'movie_pack/theatre'
require_relative 'movie_pack/theatre_builder'
require_relative 'movie_pack/web_fetcher'
require_relative 'movie_pack/slop_options'

module MoviePack
  MOVIEFILE = File.expand_path('../../data/movie_pack/movies.txt', __FILE__)

  REC_HEADERS = [:webaddr, :title, :year, :country,
                 :date, :genre, :duration, :rating,
                 :producer, :actors]

  class EncashmentError < StandardError
  end

  class ScheduleError < StandardError
  end

  Range.class_eval do
      def intersect?(other)
        if self.first <= other.first
          left = self
          right = other
        else
          left = other
          right = self
        end
        left.include?(right.first)
      end
  end
end