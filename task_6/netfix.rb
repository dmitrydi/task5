require_relative 'cinema'

class Netfix < Cinema

  def select_movie(filter = nil)
    self.filter(filter).filter_by_price(@money).collection.max_by{ |a| rand * a.rating }
  end

end