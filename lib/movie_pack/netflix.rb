require_relative 'cinema'
require_relative 'cash_desk'

module MoviePack
  # class describing on-line cinema theatre
  class Netflix < Cinema
    extend CashDesk

    def initialize(movie_array = nil)
      super
      @money = 0
      @filter_store = {}
    end

    attr_reader :money, :filter_store

    def pay(amount)
      raise ArgumentError, 'argument should be >=0' if amount < 0
      @money += amount
      self.class.put_cash(amount)
      self
    end

    def price_for(name)
      movie = @collection.find { |a| a.title == name }
      raise ArgumentError, "Movie #{name} not found" unless movie
      movie.price
    end

    def show(filter = {}, &block)
      movie = select_movie(filter, &block)
      @money -= movie.price
      puts('Now showing: ' + movie.to_s)
    end

    def select_movie(filters = {}, &block)
      filtered_collection = if block_given?
                              @collection.select(&block)
                            else
                              filter(filters, @filter_store).collection
                            end
      filtered_collection.select! { |m| m.price <= @money }
      raise "You don't have enough money" if filtered_collection.empty?
      filtered_collection.max_by { |a| rand * a.rating }
    end

    def define_filter(name, from: nil, arg: nil, &block)
      unless block
        raise ArgumentError,
              "No filter #{from} to define a filter from" unless
              @filter_store.key?(from)
        block = @filter_store[from].curry[arg]
      end
      @filter_store[name] = block
      self
    end

    class Container
      def initialize(data_hash)
        @data_hash = data_hash
      end

      attr_reader :data_hash

      def comedy
        @data_hash[:comedy]
      end

      def usa
        @data_hash[:usa]
      end
    end

    def by_genre
      data_hash =
        existing_genres.map do |a_genre, data|
          data = @collection.find_all{ |mov| mov.genre.include?(a_genre) }
          [a_genre.downcase.to_sym, data]
        end .to_h
      Container.new(data_hash)
    end

    def by_country
      countries = @collection.each.map(&:country).flatten.uniq
      data_hash = 
        countries.map do |a_country, data|
          data = @collection.find_all{ |mov| mov.country.include?(a_country) }
          [a_country.downcase.to_sym, data]
        end .to_h
      Container.new(data_hash)
    end
  end
end




