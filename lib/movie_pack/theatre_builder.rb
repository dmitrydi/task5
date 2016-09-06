module MoviePack
  # class for building a theatre
  class TheatreBuilder
    def initialize(host, &block)
      @host = host
      instance_eval(&block) if block_given?
      @host
    end

    attr_reader :host

    def hall(name, places:, title:)
      @host.halls << Hall.new(name, title, places)
      self
    end

    def period(name, &block)
      @host.periods << Period.new(name, &block)
    end

    Hall = Struct.new(:name, :title, :places)

    class Period
      def initialize(interv, &block)
        @interv = interv
        @description = MoviePack::Theatre::DEFAULT_DESCRIPTION
        @filters = {}
        @price = MoviePack::Theatre::DEFAULT_PRICE
        @hall = []
        instance_eval(&block) if block_given?
      end

      attr_reader :interv, :description, :filters, :price, :hall

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
        if list.empty?
          return (@hall.empty? ? MoviePack::Theatre::DEFAULT_HALL : @hall)
        end
        list.each { |val| @hall << val }
        self
      end

      def shown_at?(hall_name)
        @hall.include?(hall_name)
      end
    end
  end
end