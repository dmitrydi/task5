require_relative 'cinema'
require 'time'
require_relative 'cash_desk'
require_relative 'theatre_builder'

module MoviePack
  # class describing off-line cinema theatre
  class Theatre < Cinema
    include CashDesk

    MORNING = '08:00'...'11:00'
    NOON = '12:00'...'17:00'
    EVENING = '18:00'..'23:00'
    NIGHT = '00:00'..'02:00'

    class Period
      def initialize(interv, filters)
        @interv = interv
        @filters = filters
      end

      attr_reader :interv, :filters
    end

    DEFAULT_PERIODS = [
      Period.new(MORNING, { period: 'ancient' } ),
      Period.new(NOON, { genre: %w(Comedy Adventure) } ),
      Period.new(EVENING, { genre: %w(Drama Horror) } ),
      Period.new(NIGHT, { genre: %w(Drama Horror) } )
      ].freeze

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

    def periods
      if @periods
        @periods
      else
        DEFAULT_PERIODS
      end
    end

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

    attr_reader :halls 

    def select_movie(time)
      f = periods.find { |p| p.interv.include?(time) }
      raise ScheduleError, "The theatre is not scheduled for #{time}" unless f
      list_to_show = filter(f.filters).collection
      Theatre.new(list_to_show).collection.max_by { |a| rand * a.rating }
    end

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

    def buy_ticket(time)
      movie = select_movie(time)
      puts "You've bought a ticket on #{movie}"
      put_cash(movie.price)
    end
  end
end
