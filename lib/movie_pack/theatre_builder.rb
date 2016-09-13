module MoviePack
  # class for building a theatre with DSL
  class TheatreBuilder
    # @param host [Theatre] an instance of theatre to be initialized
    # @param block [Proc] block for specifying periods and halls
    # @return [Theatre] Returnes an instance of _Theatre_ class
    def initialize(host, &block)
      @host = host
      instance_eval(&block) if block_given?
      @host
    end

    # @!attribute [r] host
    # Returnes the _Theatre_ instance that called _TheatreBuilder_
    # @return [Theatre]
    attr_reader :host

    # Method for initializing halls of the _Theatre_ instance
    # @param name [Symbol] idetifier of the hall
    # @param places [Integer] number of places in the hall
    # @param title [String] title of the hall to be shown in schedule
    # @return [void]
    def hall(name, places:, title:)
      @host.halls << Hall.new(name, title, places)
      self
    end

    # Method for initializing periods of the _Theatre_ instance
    # @param name [Range<String>] period of time to which properties
    #   are define
    # @param block [Proc] block for defining description, filters,
    #   price and block properties for the period
    # @return [void]
    # @see MoviePack::TheatreBuilder::Period#description
    # @see MoviePack::TheatreBuilder::Period#filters
    # @see MoviePack::TheatreBuilder::Period#price
    # @see MoviePack::TheatreBuilder::Period#hall
    def period(name, &block)
      @host.periods << Period.new(name, &block)
    end

    # Structre [OpenStructure] for storing hall properties
    Hall = Struct.new(:name, :title, :places)

    # Utility class for initializing and storing period properties
    class Period
      # @param interv [Range<String>] time interval in format 'hh:mm'..'hh:mm'
      # @param block [Proc] block for definition of description, filters,
      #   price and hall attributes of the period
      def initialize(interv, &block)
        @interv = interv
        @description = MoviePack::Theatre::DEFAULT_DESCRIPTION
        @filters = {}
        @price = MoviePack::Theatre::DEFAULT_PRICE
        @hall = []
        instance_eval(&block) if block_given?
      end

      attr_reader :interv, :description, :filters, :price, :hall

      # Method for setting or getting the period description
      # @param a_description [String]
      # @return [self] if _a_description_ is provided
      # @return [Period#description] if used with no args
      def description(a_description = nil)
        return @description unless a_description
        @description = a_description
        self
      end

      # Method for setting or getting the period filters
      # @param some_filters [Hash<:movie_attribute => value>]
      # @return [self] if _some_filters_ are provided
      # @return [Period#filters] if used with no args
      def filters(*some_filters)
        return @filters if some_filters.empty?
        some_filters.each { |filt| @filters.merge!(filt) }
        self
      end

      # Method for setting or getting the price of tickets of the period
      # @param amount [Integer] price of tickets
      # @return [self] if _amount_ is provided
      # @return [Period#price] if used with no args
      def price(amount = nil)
        return @price unless amount
        @price = amount
        self
      end

      # Method for setting or getting the hall ids that work for the period
      # @param list [Array<Symbol>] list of hall that work during the period
      # @return [self] if _list_ is provided
      # @return [Period#hall] if used with no args
      def hall(*list)
        if list.empty?
          return (@hall.empty? ? MoviePack::Theatre::DEFAULT_HALL : @hall)
        end
        list.each { |val| @hall << val }
        self
      end

      # Method for checking whether a hall with id _hall_name_
      # is working during the period
      # @param hall_name [Symbol] hall id
      # @return [Boolean] true if the hall work during the period
      def shown_at?(hall_name)
        @hall.include?(hall_name)
      end
    end
  end
end