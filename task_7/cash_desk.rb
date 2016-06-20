module CashDesk

  def self.included(base)
    base.extend(ClassMethods)
  end

  attr_reader :cash

  def cash
    @cash ||= 0
  end

  def put_cash(amount)
    raise ArgumentError, "Amount of cash should be >= 0" if amount < 0
    @cash = cash + amount
  end

    module ClassMethods
      @@cash = 0 

      def cash
        @@cash
      end

      def put_cash(amount)
        raise ArgumentError, "Amount of cash should be >= 0" if amount < 0
        @@cash += amount
      end
    end

end