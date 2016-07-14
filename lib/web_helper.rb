require 'open-uri'
require 'fileutils'

module WebHelper
# module for getting and storing web-pages
BASE_PATH = File.expand_path('../../data/tmp/', __FILE__)
SITE_STR = 'http://www.imdb.com/'

  def self.cashed_get(url)
    file_name = self.get_name_for(url)
    if File.exists?(file_name)
      File.read(file_name)
    else
      url_contents = open(url).read
      FileUtils.mkdir_p BASE_PATH
      File.write(file_name, url_contents)
      url_contents
    end
  end

  def self.get_name_for(url)
    File.join(BASE_PATH, self.url_to_filename(url))
  end

  def self.url_to_filename(url)
    url.gsub(SITE_STR, '')
       .gsub(/(\/\?|\?).*/, '')
       .gsub("/", '_') \
       + '.html'
  end
end

