require_relative 'movie'
require_relative 'movie_collection'
require_relative 'movie_to_show'

class Netfix < MovieCollection
  def initialize(movie_array = nil)
    super(movie_array)
    @money = 0
  end

  attr_reader :collection, :money

  def read(filename = "movies.txt")
    @collection = CSV.read(filename, col_sep: "|").map {|a| MovieToShow.new(a, self)}
    self
  end

  def self.read(filename = "movies.txt")
    Netfix.new.read(filename)
  end

  def pay(amount)
    @money += amount
  end

  def films_by_producers
    @movs_by_producers ? @movs_by_producers : @movs_by_producers = @collection.group_by {|a| a.producer}.map{|key, val| [key,val.map {|a| a.title}]}.to_h
  end

  def make_shortlist(filter = nil)
    list_to_show = if filter
                      self.filter(filter).collection 
                    else
                      self.collection
                    end
    if list_to_show.length == 0
      raise ArgumentError, "no films found with given parameters"
    else
      list_to_show.find_all {|a| a.price.to_i <= @money}
    end
  end

  def gen_number(shortlist)
    Random.new.rand(0..shortlist.length)
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

end