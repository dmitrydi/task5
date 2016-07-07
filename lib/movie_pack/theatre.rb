require_relative 'cinema'
require 'time'
require_relative 'cash_desk'
require_relative 'theatre_builder'

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
      @halls = []
      @periods = []
      if block_given?
        TheatreBuilder.new(self, &block)
        check_schedule
        self.read
      end
    end

    def check_schedule
      @halls.each do |hall|
        @periods
          .select { |p| p.shown_at?(hall.name) }
          .map { |p| p.interv }
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

    attr_reader :halls, :periods

    def select_movie(time)
      filters =
        if @periods.empty?
          hour = Time.parse(time).hour
          f = FILTERS_FOR_PERIODS.find { |k, _v| k.include?(hour) }
          raise ArgumentError, "The cinema is closed in #{time}" unless f
          f[1]
        else
          f = @periods.find { |p| p.interv.include?(time) }
          raise ArgumentError, "The theatre is not scheduled for #{time}" unless f
          f.filters
        end
      list_to_show = filter(filters).collection
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
