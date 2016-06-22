require_relative 'error_classes'

module MoviePack

  module CashDesk

    def cash
      @cash ||= 0
    end

    def put_cash(amount)
      raise ArgumentError, "Amount of cash should be >= 0" if amount < 0
      @cash = cash + amount
    end

    def take(who)
  	  raise EncashmentError, "#{who} is not permitted to take cash" unless who == 'Bank'
  	  puts "Cash collected by #{who}, amount taken: #{cash}"
  	  @cash = 0
    end
  end

end