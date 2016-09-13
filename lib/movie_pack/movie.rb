require 'date'
require 'virtus'
require_relative 'movie_collection'

module MoviePack
  # class describing Movie object, parent for MovieToShow,
  # AncientMovie, ClassicMovie, ModernMovie, NewMovie
  class Movie
    # (see Virtus::InstanceMethods::Constructor)
    include Virtus.model

     # utility class for splitting a comma-delimited string
    class SplitString < Virtus::Attribute
      # (see Virtus::Attribute#coerce)
      def coerce(str)
        str.split(',')
      end
    end

    # utilty class for storing duration of the movie in Fixnum format
    class ForcedInt < Virtus::Attribute
      # (see Virtus::Attribute#coerce)
      def coerce(val)
        val.to_i
      end
    end

    # @!macro [attach] mov.attr
    #   @!attribute [r] $1
    #     $1 of the movie
    #     @return [$2]
    attribute :webaddr, String
    attribute :title, String
    attribute :year, ForcedInt
    attribute :country, String
    attribute :date, String
    attribute :genre, SplitString
    attribute :duration, ForcedInt
    attribute :rating, Float
    attribute :producer, String
    attribute :actors, SplitString

    # @param args [Hash{[MoviePack::REC_HEADERS] => values}]
    # @param host [MoviePack::MovieCollection]
    def initialize(args, host = nil)
      super(args)
      @host = host
    end

    # @return [Fixnum] abbreviated name of the month of production date of the movie
    def month
      Date::ABBR_MONTHNAMES[date.split('-')[1].to_i]
    end

    def to_s
      "#{title}, #{year}, #{country}, #{genre.join(', ')}, " \
       "#{duration} min, raitng: #{rating}, producer: #{producer}, " \
       "starring: #{actors.join(', ')}"
    end

    # @param a_genre [String] name of a movie genre
    # @return [Boolean]
    # @raise [ArgumentError] if the movie collection (host.collection)
    #   does not include a_genre for any movie
    def has_genre?(a_genre)
      if @host && !@host.genre_exists?(a_genre)
        raise ArgumentError, "Genre: #{a_genre} does not exist"
      end
      genre.any? { |v| a_genre.include?(v) }
    end

    # @param key [Symbol] name of a movie atribute
    # @param val [Array, Range, Numeric, String]
    # @return [Boolean] true when movie attribute key somehow matches val
    def match?(key, val)
      key_val = self.send(key)
      case val
      when Array
        val.any? { |v| caseless_include?(key_val, v) }
      when Range
        val.include?(key_val)
      when Numeric
        key_val == val
      else
        caseless_include?(key_val, val)
      end
    end

    # @param val [String, Array<String>]
    # @param cmp [String]
    # @return [Boolean] true if any of val includes cmp, case insensitive
    def caseless_include?(val, cmp)
      if val.is_a?(Array)
        val.any? { |x| x.casecmp(cmp) == 0 }
      else
        val.casecmp(cmp) == 0
      end
    end
  end
end
