module MoviePack
  # module for building a theatre
  module TheatreBuilder
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
  end
end