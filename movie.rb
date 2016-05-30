require 'date'

class Movie
  def initialize(record, host = nil)
    @host = host

    @webaddr = record[0]

    @title = record[1]

    @year = record[2]

    @country = record[3]

    @date = record[4]

    @genre = record[5].split(",")

    @duration = record[6].to_i

    @rating = record[7]

    @producer = record[8]

    @actors = record[9].split(",")

    if @date.count("-") == 0
      @month = 'nil'
    else
      @month = Date::ABBR_MONTHNAMES[@date.split("-")[1].to_i]
    end
  end

  attr_reader :webaddr, :title, :year, :country, :date, :genre, :duration, :rating, :producer, :actors, :month
 
  def to_s
    "#{@title}, #{@year}, #{@country}, #{@genre.join(", ")}, #{duration} min, raitng: #{@rating}, producer: #{@producer}, starring: #{@actors.join(", ")}"
  end

  def has_genre?(genre)
    if @host
      if @host.genre_exists?(genre)
        @genre.include?(genre)
      else
        raise ArgumentError, "Genre: #{genre} does not exist"
      end
    else
      @genre.include?(genre)
    end
  end
end