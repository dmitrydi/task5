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
      def initialize(owner)
        @owner = owner
        class << self
          @owner.existing_genres.each do |a_genre|
            define_method "#{a_genre.downcase}" do
              @owner.filter(genre: a_genre)
            end
          end
        end
      end

      #def comedy
      #  @owner.filter(genre: 'Comedy')
      #end

      def usa
        @owner.filter(country: 'USA')
      end
    end

    def by_genre
      Container.new(self)
    end

    def by_country
      Container.new(self)
    end
  end
end




