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


  def time_for(title)
    movie = self.filter(title: title).collection.first
    time = if movie.period == 'ancient'
             rand(MORNING)  
           else
             genre = movie.genre
           case 
             when genre.include?('Comedy'), genre.include?('Adventure')
               rand(NOON)
             when genre.include?('Drama'), genre.include?('Horror')
               rand(0..1) == 0 ? rand(EVENING) : rand(NIGHT)
             else
               raise ArgumentError, "film is not in the schedule"
           end
          end
    time <= 9 ? ("0%d:00" %time) : ("%d:00" %time)
  end

end