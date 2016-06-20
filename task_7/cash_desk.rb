module CashDesk

  def cash
    @cash ||= 0
  end

  def put_cash(amount)
    raise ArgumentError, "Amount of cash should be >= 0" if amount < 0
    @cash = cash + amount
  end

end