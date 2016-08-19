require 'nokogiri'
require 'open-uri'
require 'progress-bar'
require 'yaml'
require 'fileutils'
require 'themoviedb-api'
require_relative 'web_fetcher/imdb_budgets'
require_relative 'web_fetcher/tmdb_data'
require_relative 'web_fetcher/web_helper'

module MoviePack::WebFetcher
  DATA_PATH = File.expand_path('../../../data/movie_pack/web_fetcher', __FILE__)
  TMP_PATH = File.join(DATA_PATH, 'tmp')
  POSTERS_PATH = File.join(DATA_PATH, 'posters')
  API_KEY_FILE = File.expand_path('../../../config/web_fetcher/tmdb.yml', __FILE__)
  DEFAULT_ID_FILE = File.join(DATA_PATH, 'id_list.yml')
  ALT_TITLES_FILE = File.join(DATA_PATH, 'alt_titles.yml')
  DOMAIN = 'http://www.imdb.com'
  TOP_250_URL = 'http://www.imdb.com/chart/top?ref_=nv_mv_250_6'
  BASE_IMAGE_URL = 'http://image.tmdb.org/t/p/w185'

  def self.id_from(url)
      url.scan(/tt\d{7}/).first || url.gsub(DOMAIN, '').gsub(/\?.*/,'').gsub(/\//,'_')
  end

end