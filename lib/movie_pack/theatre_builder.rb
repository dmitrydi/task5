module MoviePack
  # class for building a theatre
  class TheatreBuilder
    def initialize(host, &block)
      @host = host
      instance_eval(&block)
      @host
    end

    def hall(name, places:, title:)
      @host.halls[name] = [title, places]
      self
    end

    def period(name, &block)
      @host.periods[name] = Period.new(&block)
    end

    class Period
      def initialize(&block)
        @description = ''
        @filters = {}
        @price = 0
        @hall = []
        instance_eval(&block)
      end

      attr_reader :description, :filters, :price, :hall

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
  end
end