require_relative 'cinema'
require 'time'

class Theatre < Cinema

  def select_movie(time)
    raise ArgumentError, "enter time from 08:00 to 02:59" unless time
    list_to_show = case Time.parse(time).hour
                    when 8..11
                      self.filter(period: 'ancient').collection
                    when 12..17
                      self.filter(genre: 'Comedy').collection + self.filter(genre: 'Adventure').collection
                    when 18..23, 0..2 
                      self.filter(genre: 'Drama').collection + self.filter(genre: 'Horror').collection
                    else
                      raise ArgumentError, "The cinema is closed from 03:00 to 07:59"
                   end
    list_to_show.max_by{ |a| rand * a.rating }
  end

end