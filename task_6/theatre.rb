require_relative 'movie_collection'
require_relative 'movie_to_show'
require_relative 'netfix'
require 'time'

class Theatre < Netfix
  def make_shortlist(time)
    list_to_show = case Time.parse(time).hour
                    when 8..11
                      self.filter(period: 'ancient')
                    when 12..17
                      self.filter(genre: 'comedy') + self.filter(genre: 'adventure')
                    when (18..23 || 0..2)
                      self.filter(genre: 'drama') + self.filter(genre: 'horror')
                    else
                      raise ArgumentError, "The cinema is closed from 02:59 to 07:59"
                   end
  end


end