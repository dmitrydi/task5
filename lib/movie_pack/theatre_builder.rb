module MoviePack
  # class for building a theatre
  class TheatreBuilder
    def initialize(host, &block)
      @host = host
      instance_eval(&block)
      @host
    end

    def hall(name, places:, title:)
      @host.halls << Hall.new(name, title, places)
      self
    end

    Hall = Struct.new(:name, :title, :places)

    def period(name, &block)
      @host.periods << Period.new(name, &block)
    end

    class Period
      def initialize(interv, &block)
        @interv = interv
        @description = ''
        @filters = {}
        @price = 0
        @hall = []
        instance_eval(&block)
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
        return @hall if list.empty?
        list.each { |val| @hall << val }
        self
      end

      def shown_at?(hall_name)
        self.hall.any? { |h| h == hall_name }
      end
    end
  end
end