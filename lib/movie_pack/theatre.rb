require_relative 'cinema'
require 'time'
require_relative 'cash_desk'
require_relative 'theatre_builder'

module MoviePack
  # class describing off-line cinema theatre
  class Theatre < Cinema
    include CashDesk

    # default periods of time for scheduling
    MORNING = '08:00'...'11:00'
    NOON = '12:00'...'17:00'
    EVENING = '18:00'..'23:00'
    NIGHT = '00:00'..'02:00'

    # class for storing a period of time parameters in a single instance
    class Period
      # Creates a new instance
      # @param interv [Range<String>] time range described
      # @param filters [Hash{ :attr => desired_value }] filters for movie collection for the time range described.
      #   :attr and desired_value are attributes of instances of Movie class.
      #   @see MoviePack::Movie
      # @param hall [Array<Symbol>] names of the halls for that the period of schedule is described
      # @param price [Fixnum] price of the ticket during the period
      # @param description [String] arbitrary description
      def initialize(
        interv,
        filters,
        hall = [DEFAULT_SYM],
        price = DEFAULT_PRICE,
        description = DEFAULT_DESCRIPTION
      )
        @interv = interv
        @description = description
        @filters = filters
        @price = price
        @hall = hall
      end

      attr_reader :interv, :filters, :hall, :price, :description
    end

    DEFAULT_SYM = :main_hall
    DEFAULT_HALL = Struct.new(:name, :title, :places).new(DEFAULT_SYM, 'Main Hall', 100).freeze
    DEFAULT_PRICE = 10
    DEFAULT_DESCRIPTION = 'Famous cinema hall'
    DEFAULT_PERIODS = [
      Period.new(MORNING, { period: 'ancient' } ),
      Period.new(NOON, { genre: %w(Comedy Adventure) } ),
      Period.new(EVENING, { genre: %w(Drama Horror) } ),
      Period.new(NIGHT, { genre: %w(Drama Horror) } )
      ].freeze

    # creates an instance of Theare class
    # @param movie_array [Array<Movie>] collection of Movie instances.
    # @see MoviePack::Movie
    # @param block [Proc] code block for setting halls and periods.
    # @see MoviePack::TheatreBuilder#hall
    # @see MoviePack::TheatreBuilder#period
    def initialize(movie_array = nil, &block)
      super(movie_array)
      if block_given?
        @halls = []
        @periods = []
        TheatreBuilder.new(self, &block)
        check_schedule
        self.read unless movie_array
      end
    end

    # @return periods defined for [Teatre] instance
    def periods
      @periods || DEFAULT_PERIODS
    end

    # @return halls defined for [Teatre] instance
    def halls
      @halls || [DEFAULT_HALL]
    end

    # @return [Boolean] true if no crossings in schedule
    # @raise [ScheduleError] if any crossings in schedule
    def check_schedule
      @halls.each do |hall|
        periods
        .select { |p| p.shown_at?(hall.name) }
        .map(&:interv)
        .combination(2)
        .each do |left, right| 
          if left.intersect?(right)
            raise ScheduleError,
              "Time intersection for #{hall.name}: #{left} #{right}"
          end
        end
      end
      true
    end

    # @param time [String] time in format 'hh:mm'
    # @return [MoviePack::Movie] a movie with attributes filtered with filter 
    #   defined for period which includes time
    # @raise [ScheduleError] if no periods defined that include time
    def select_movie(time)
      f = periods.find { |p| p.interv.include?(time) }
      raise ScheduleError, "The theatre is not scheduled for #{time}" unless f
      list_to_show = filter(f.filters).collection
      Theatre.new(list_to_show).collection.max_by { |a| rand * a.rating }
    end

    # @param title [String] title of the movie
    # @return [String] time in format 'hh:mm' for movie
    # @raise [ArgumentError] if movie does not correspond to any
    #   filters defined in periods
    def time_for(title)
      movie = filter(title: title).collection.first
      period = 
        periods
        .find { |p| p.filters.map { |k , v| movie.match?(k, v) } .all? }
      raise ArgumentError, 'Film is not in the schedule' unless period
      period = period.interv
      time = rand((period.first.to_i)..(period.last.to_i))
      ('%02d:00' % time)
    end

    def show(time)
      puts 'Now showing: ' + select_movie(time).to_s
    end

    def select_hall(halls_ary)
      hall_sym = halls_ary[rand(0..(halls_ary.length - 1))]
      halls.find { |h| h.name == hall_sym } .title
    end

    # @param time [String] desirable time to watch movie
    #   in 'hh:mm' format
    # @return [void]
    # prints a message "You've bought a ticket on #{movie}, hall: #{hall}"
    # where movie and hall - movie and hall titles, respectively
    # puts in cash desk amount of money equal to ticket price for the period
    # which includes _time_.
    # @raise [ArgumentError] when time does not correspond to any 
    #   periods of instance defined in #initialize block
    def buy_ticket(time)
      movie = select_movie(time)
      shown_period = periods.find { |p| p.interv.include?(time) }
      hall = select_hall(shown_period.hall)
      puts "You've bought a ticket on #{movie}, hall: #{hall}"
      put_cash(shown_period.price)
    end
  end
end
