require_relative 'movie_classes'

class Netfix < MovieCollection
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

  def make_shortlist(filt = nil)
    list_to_show =  filt ? self.filter(filt).collection :  self.collection
    if list_to_show.length == 0
      raise ArgumentError, "no films found with given parameters"
    else
      list_to_show = list_to_show.find_all {|a| a.price <= @money}
      raise ArgumentError, "you don't have enough money"
    end
  end

  def gen_number(shortlist, scale = 2)
    s = 0.0
    rmin = shortlist.min_by {|a| a.rating}.rating
    rmax = shortlist.max_by {|a| a.rating}.rating
    if rmin == rmax
      k = 0
      b = 1
    else
      k = (scale - 1)/(rmax - rmin)
      b = 1 - k * rmin
    end
    sum_rating_ary = shortlist.map{|a| s += (k*a.rating + b)}
    rnd = Random.new.rand(0..sum_rating_ary.last)
    sum_rating_ary.index {|a| a >= rnd}
  end

  def show(filter = nil)
    shortlist = make_shortlist(filter)
    if shortlist.length == 0
      raise RuntimeError, "you don't have enough money"
    elser
      #n = gen_number(shortlist)
      mov = shortlist.max_by{|a| rand ** (1/a.rating)}
      @money -= shortlist[n].price
      "Now showing: " + shortlist[n].to_s
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

end