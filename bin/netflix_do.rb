require_relative '../lib/movie_pack'
require 'slop'

module Slop
  class FiltersOption < ArrayOption
    def finish(params)
      dummy_hash =
        self.value.map do |f|
          f1,f2 = f.split(':')
          { f1.to_sym => f2 }
        end
        .reduce(:merge)
      p dummy_hash
      self.value = FilterParser.new(dummy_hash).to_h
    end

    class FilterParser
      include Virtus.model

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

      def initialize(hash)
        super(hash)
      end
    end
  end
end

opts = Slop.parse do |o|
  o.integer '--pay', default: 0
  o.filters '--filters', delimiter: ';'
end

puts opts[:filters]