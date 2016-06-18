require 'date'
require_relative 'movie_collection'

class Movie
  def initialize(record, host = nil)
    @host = host
    @webaddr = record[0]
    @title = record[1]
    @year = record[2].to_i
    @country = record[3]
    @date = record[4]
    @genre = record[5].split(",")
    @duration = record[6].to_i
    @rating = record[7].to_f
    @producer = record[8]
    @actors = record[9].split(",")
    @month = Date::ABBR_MONTHNAMES[@date.split("-")[1].to_i]
  end

  attr_reader :webaddr, :title, :year, :country, :date, :genre, :duration, :rating, :producer, :actors, :month
 
  def to_s
    "#{@title}, #{@year}, #{@country}, #{@genre.join(", ")}, #{duration} min, raitng: #{@rating}, producer: #{@producer}, starring: #{@actors.join(", ")}"
  end

  def has_genre?(genre)
    if @host && !@host.genre_exists?(genre)
      raise ArgumentError, "Genre: #{genre} does not exist"
    end
    @genre.include?(genre)
  end

  def match?(key, val)
    key_val = self.send(key)
    if key_val.is_a?(Numeric)
      key_val == val
    else
      key_val.include?(val)
    end
  end

  def any_match?(key, val)
    return match?(key, val) unless val.is_a?(Array)
    key_val = self.send(key)
    val.inject(false) { |memo, v| memo || key_val.include?(v) }
  end

end