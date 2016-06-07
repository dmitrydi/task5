require_relative 'movie_classes'

class Netfix < MovieCollection
  def initialize(movie_array = nil)
    super(movie_array)
    @money = 0
  end

  attr_reader :collection, :money

  def read(filename = "movies.txt")
    @collection = CSV.read(filename, col_sep: "|").map {|a| MovieToShow.create(a, self)}
    self
  end

  def self.read(filename = "movies.txt")
    Netfix.new.read(filename)
  end

  def pay(amount)
    if amount < 0
      raise ArgumentError, "argument should be >=0"
    else
      @money += amount
      self
    end
  end

  def films_by_producers
    @movs_by_producers ? @movs_by_producers : @movs_by_producers = @collection.group_by {|a| a.producer}.map{|key, val| [key,val.map {|a| a.title}]}.to_h
  end

  def make_shortlist(filter = nil)
    list_to_show =  if filter
                      self.filter(filter).collection 
                    else
                      self.collection
                    end
    if list_to_show.length == 0
      raise ArgumentError, "no films found with given parameters"
    else
      list_to_show.find_all {|a| a.price.to_i <= @money}
      list_to_show
    end
  end

  def gen_number(shortlist)
    s = 0.0
    sum_rating_ary = shortlist.map {|a| s += a.rating.to_f}
    rnd = Random.new.rand(0..sum_rating_ary.last)
    sum_rating_ary.index {|a| a >= rnd}
  end

  def show(filter = nil)
    shortlist = make_shortlist(filter)
    if shortlist.length == 0
      raise RuntimeError, "you don't have enough money"
    else
      n = gen_number(shortlist)
      @money -= shortlist[n].price
      "Now showing: " + shortlist[n].to_s
    end
  end

  def how_much?(name)
    begin
      @collection.find{|a| a.title == name}.price
    rescue
      raise ArgumentError, "no such movie"
    end
  end

end