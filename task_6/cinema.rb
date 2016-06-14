require_relative 'movie_classes'

class Cinema < MovieCollection
  def initialize(movie_array = nil)
    super
    @money = 0
  end

  attr_reader :money

  def read(filename = "movies.txt")
    @collection = CSV.read(filename, col_sep: "|").map {|a| MovieToShow.create(a, self)}
    self
  end

  def pay(amount)
    if amount < 0
      raise ArgumentError, "argument should be >=0"
    else
      @money += amount
      self
    end
  end

  def how_much?(name)
    movie = @collection.find{|a| a.title == name}
    unless movie
      raise ArgumentError, "no such movie"
    else
      movie.price
    end
  end

  def inspect
    self.stats(:period)
  end

  def filter_by_price(money)
    filtered_collection = @collection.find_all {|a| a.price <= money}
    if filtered_collection.length == 0
      raise RuntimeError, "you don't have enough money"
    else
      self.class.new(filtered_collection)
    end
  end

  def show(filter = nil)
    movie = select_movie(filter)
    @money -= movie.price
    puts("Now showing: " + movie.to_s)
  end

end
