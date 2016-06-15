require_relative 'cinema'
require 'time'

class Theatre < Cinema
MORNING = 8..11
NOON = 12..17
EVENING = 18..23
NIGHT = 0..2
  def select_movie(time)
    raise ArgumentError, "enter time from 08:00 to 02:59" unless time
    list_to_show = case Time.parse(time).hour
                    when MORNING
                      self.filter(period: 'ancient').collection
                    when NOON
                      self.filter(genre: 'Comedy').collection + self.filter(genre: 'Adventure').collection
                    when EVENING, NIGHT
                      self.filter(genre: 'Drama').collection + self.filter(genre: 'Horror').collection
                    else
                      raise ArgumentError, "The cinema is closed from 03:00 to 07:59"
                   end
    Theatre.new(list_to_show).pay(@money).filter_by_price(@money).collection.max_by{ |a| rand * a.rating }
  end

end