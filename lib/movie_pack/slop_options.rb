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
      self.value = FilterParser.new(dummy_hash).to_filters
    end

    class FilterParser
      include Virtus.model

      class SplitString < Virtus::Attribute
      # (see Virtus::Attribute#coerce)
        def coerce(str)
          str.split(',') if str
        end
      end

    # utilty class for storing duration of the movie in Fixnum format
      class ForcedInt < Virtus::Attribute
      # (see Virtus::Attribute#coerce)
        def coerce(val)
          val.to_i
        end
      end

      attribute :title, String
      attribute :year, Integer
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

      def to_filters
        hash = self.to_h
        hash.reject { |k, v| v.nil? || v == 0 || v == 0.0 }
      end
    end
  end
end