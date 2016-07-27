require 'open-uri'

class Test
  URL = 'http://www.imdb.com/chart/top?ref_=nv_mv_250_6'
  def self.fetch_page
    File.write('c:/test.html', open(URL).read)
  end
end