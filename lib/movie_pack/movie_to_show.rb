require_relative 'movie_classes'
require 'date'

module MoviePack
  # class describing Movies to show in Cinema
  class MovieToShow < Movie
    def initialize(record, host = nil)
      super
      check_year(@year)
    end

    def price
      self.class::PRICE
    end

    def period
      self.class.to_s.split('::').last.downcase.sub('movie', '')
    end

    def self.create(record, host = nil)
      klass =
        [AncientMovie, ClassicMovie, ModernMovie, NewMovie]
        .detect { |clas| clas::PERIOD.include?(record[2].to_i) } or
        raise ArgumentError,
              'Error in MovieToShow#create: unrecognized value of year'

      klass.new(record, host)
    end

    private

    def check_year(year)
      raise ArgumentError,
            "year should be in range #{period}" unless
            self.class::PERIOD.include?(year)
    end
  end
end
