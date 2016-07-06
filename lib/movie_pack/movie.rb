require 'date'
require 'virtus'
require_relative 'movie_collection'

module MoviePack
  # class describing Movie object, parent for MovieToShow,
  # AncientMovie, ClassicMovie, ModernMovie, NewMovie
  class Movie
    include Virtus.model

     # utility class for splitting a comma-delimited string
    class SplitString < Virtus::Attribute
      def coerce(str)
        str.split(',')
      end
    end

    class ForcedInt < Virtus::Attribute
      def coerce(val)
        val.to_i
      end
    end

    attribute :webaddr, String
    attribute :title, String
    attribute :year, Integer
    attribute :country, String
    attribute :date, String
    attribute :genre, SplitString
    attribute :duration, ForcedInt
    attribute :rating, Float
    attribute :producer, String
    attribute :actors, SplitString

    def initialize(args, host = nil)
      super(args)
      @host = host
    end

    def month
      Date::ABBR_MONTHNAMES[date.split('-')[1].to_i]
    end

    def to_s
      "#{title}, #{year}, #{country}, #{genre.join(', ')}, " \
       "#{duration} min, raitng: #{rating}, producer: #{producer}, " \
       "starring: #{actors.join(', ')}"
    end

    def has_genre?(a_genre)
      if @host && !@host.genre_exists?(a_genre)
        raise ArgumentError, "Genre: #{a_genre} does not exist"
      end
      genre.any? { |v| a_genre.include?(v) }
    end

    def match?(key, val)
      key_val = self.send(key)
      return val.inject(false) { |memo, v| memo || caseless_include?(key_val, v) } if val.is_a?(Array)
      key_val.is_a?(Numeric) ? (key_val == val) : caseless_include?(key_val, val)
    end

    private
    def caseless_include?(val, cmp)
      if val.is_a?(Array)
        val.any? { |x| x.casecmp(cmp) == 0 }
      elsif val.is_a?(Range)
        val.include?(cmp)
      else
        val.casecmp(cmp) == 0
      end
    end
  end
end
