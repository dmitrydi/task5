require_relative 'cinema'
require 'time'
require_relative 'cash_desk'

module MoviePack
  # class describing off-line cinema theatre
  class Theatre < Cinema
    include CashDesk

    MORNING = 8..11
    NOON = 12..17
    EVENING = 18..23
    NIGHT = 0..2
    FILTERS_FOR_PERIODS = {
      MORNING => { period: 'ancient' },
      NOON => { genre: %w(Comedy Adventure) },
      EVENING => { genre: %w(Drama Horror) },
      NIGHT => { genre: %w(Drama Horror) }
    }.freeze

    def initialize(movie_array = nil, &block)
      super(movie_array)
      @halls = {}
      @periods = {}
      if block_given?
        instance_eval(&block)
      end
    end

    attr_reader :halls, :periods

    def hall(name, places: 0, title: '')
      @halls.merge!(name => [title, places])
      self
    end

    def period(name, &block)
      container = Container.new
      container.fill(&block)
      @periods.merge!(name => container)
    end

    class Container
      def initialize
        @description = ''
        @filters = {}
        @price = 0
        @hall = []
      end

      attr_reader :description, :filters, :price, :hall

      def fill(&block)
        instance_eval(&block)
      end

      def description(a_description = nil)
        return @description unless a_description
        @description = a_description
        self
      end

      def filters(*some_filters)
        return @filters if some_filters.empty?
        some_filters.each { |filt| @filters.merge!(filt) }
        self
      end

      def price(amount = nil)
        return @price unless amount
        @price = amount
        self
      end

      def hall(*list)
        return @hall if list.empty?
        list.each { |val| @hall << val }
        self
      end
    end


    def select_movie(time = nil)
      raise ArgumentError, 'Enter time from 08:00 to 02:59' unless time
      hour = Time.parse(time).hour
      filters = FILTERS_FOR_PERIODS.find { |k, _v| k.include?(hour) }
      raise ArgumentError, "The cinema is closed in #{time}" unless filters
      list_to_show = filter(filters[1]).collection
      Theatre.new(list_to_show).collection.max_by { |a| rand * a.rating }
    end

    def time_for(title)
      movie = filter(title: title).collection.first
      period = FILTERS_FOR_PERIODS
               .find { |_k, v| movie.match?(v.keys.first, v.values.first) }
      raise ArgumentError, 'Film is not in the schedule' unless period
      period = period[0]
      time = rand(period)
      ('%02d:00' % time)
    end

    def show(time)
      puts 'Now showing: ' + select_movie(time).to_s
    end

    def buy_ticket(time)
      movie = select_movie(time)
      puts "You've bought a ticket on #{movie}"
      put_cash(movie.price)
    end
  end
end
