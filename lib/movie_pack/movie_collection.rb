require 'csv'
require_relative 'movie'

module MoviePack
  # Class describing collection of Movie instances
  class MovieCollection
    include Enumerable

    def initialize(movie_array = nil)
      @collection = movie_array
    end

    attr_reader :collection

    def create_movie(record, host = nil)
      Movie.new(record, host)
    end

    def read(filename = MoviePack::MOVIEFILE)
      @collection = CSV.read(
                             filename, col_sep: '|',
                             headers: MoviePack::REC_HEADERS
                            )
                        .map { |a| create_movie(a, self) }
      self
    end

    def self.read(filename = MoviePack::MOVIEFILE)
      new.read(filename)
    end

    def existing_genres
      @existing_genres = @collection.each.map(&:genre).flatten.uniq
    end

    def genre_exists?(genre)
      existing_genres unless @existing_genres
      @existing_genres.include?(genre)
    end

    def to_s
      @collection.join("\n")
    end

    def films_by_producers
      @movs_by_producers ||= @collection
                             .group_by(&:producer)
                             .map { |key, val| [key, val.map(&:title)] }
                             .to_h
    end

    def first(n = nil)
      if n
        MovieCollection.new(@collection.first(n))
      else
        @collection[0]
      end
    end

    def [](n)
      MovieCollection.new([@collection[n]])
    end

    alias all collection

    def sort_by(key)
      MovieCollection.new(@collection.sort_by { |a| a.send(key) })
    end

    def filter(filt = {}, filter_store = {})
      return self if filt.empty?

      filtered_collection =
        filt.inject(@collection) do |memo, (k, v)|
          block = filter_store[k]
          memo.select { |m| block ? call_block(block, v, m, k) : m.match?(k, v) }
        end

      raise ArgumentError,
            "No movies found with filter #{filt}" if filtered_collection.empty?

      self.class.new(filtered_collection)
    end

    def stats(key)
      @collection
        .group_by { |a| a.send(key) }
        .map { |k, v| [k, v.count] }
        .to_h
    end

    def each(&block)
      @collection.each(&block)
    end

    private

    def call_block(block, v, m, k)
      if block.arity.abs == 1
        block.call(m)
      elsif v.is_a?(Array)
        v.inject(block) { |memo, val| memo.curry[val] }.call(m, k)
      else
        block.call(v, m, k)
      end
    end
  end
end
