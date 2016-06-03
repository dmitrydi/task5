require_relative 'movie'
require 'date'

class MovieToShow < Movie
  def initialize(record, host = nil)
    super(record, host)
<<<<<<< HEAD
    @period = case @year
              when 1900..1945
                'ancient'
              when 1946..1968
                'classic'
              when 1969..2000
                'modern'
              when 2000..2016
                'new'
              else
                nil
              end
  end
  attr_reader :period
=======

    @period = case @year.to_i
                when 1900..1945
                  'ancient'
                when 1946..1968
                  'classic'
                when 1969..2000
                  'modern'
                when 2000..Date.today.year
                  'new'
                else
                  nil
              end

    @price = case @period
                when 'acnient'
                  1
                when 'classic'
                  1.5
                when 'modern'
                  3
                when 'new'
                  5
                else
                  nil
              end 
  end

  attr_reader :period, :price

  def to_s
    case @period
    when 'ancient'
      "#{@title} - old movie (#{@year})"
    when 'classic'
      "#{@title} - classic movie, producer: #{@producer}"
    when 'modern'
      "#{@title} - modern movie, starring: #{@actors.join(', ')}"
    when 'new'
      "#{@title} - new film, released #{Date.today.year - @year} years ago!"
    else
      raise RuntimeError, "Unable to classify movie #{title}"
    end
  end


>>>>>>> 4c7ee3ca3570c2cb3978e8b281250ae6e0d596bb
end
