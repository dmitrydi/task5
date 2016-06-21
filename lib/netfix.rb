require_relative 'cinema'
require_relative 'cash_desk'

class Netfix < Cinema

  extend CashDesk

  def initialize(movie_array = nil)
    super
  	@money = 0
  end

  attr_reader :money

  def pay(amount)
    raise ArgumentError, "argument should be >=0" if amount < 0
    @money += amount
    Netfix.put_cash(amount)
    self
  end

  def price_for(name)
    movie = @collection.find{|a| a.title == name}
    raise ArgumentError, "Movie #{name} not found" unless movie
    movie.price
  end

  def show(filter = nil)
    movie = select_movie(filter)
    @money -= movie.price
    puts("Now showing: " + movie.to_s)
  end

  def select_movie(filters = nil)
    filtered_collection = filter(filters).collection
    filtered_collection.select! { |m| m.price <= @money }
    raise "You don't have enough money" if filtered_collection.empty?
    filtered_collection.max_by{ |a| rand * a.rating }
  end

end