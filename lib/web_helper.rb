require 'open-uri'

class WebHelper
# class for getting and storing web-pages
BASE_PATH = File.expand_path('../../data/web_pages/', __FILE__)
SITE_STR = "http://www.imdb.com/"

  def self.file_create(url)
    file_name = self.get_full_name(url)
    unless File.exists?(file_name)
      file = open(url)
      File.write(file_name, file.read)
    end
    file_name
  end

  def self.get_full_name(url)
    BASE_PATH + '/' + self.parse_url(url)
  end

  def self.parse_url(url)
    url.gsub(SITE_STR, '')
       .gsub(/(\/\?|\?).*/, '')
       .gsub("/", '_') \
       + '.html'
  end
end

