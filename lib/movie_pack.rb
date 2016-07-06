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
      def intersect?(b, include_ends = true)
        if self.first <= b.first
          left = self
          right = b
        else
          left = b
          right = self
        end
        include_ends ? (right.first <= left.last) : (right.first < left.last )
      end
  end
end