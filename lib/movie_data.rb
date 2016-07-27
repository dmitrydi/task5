require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'progress-bar'
require 'yaml'
require 'fileutils'
require 'themoviedb-api'
require_relative 'movie_data/imdb_budgets'
require_relative 'movie_data/tmdb_data'
require_relative 'movie_data/web_helper'

module MovieData
  TOP_250_URL = 'http://www.imdb.com/chart/top?ref_=nv_mv_250_6'
  DATA_PATH = File.expand_path('../../data/movie_data/', __FILE__)
  TMP_PATH = File.expand_path('../../data/movie_data/tmp/', __FILE__)
  DOMAIN = 'http://www.imdb.com'
  API_KEY_FILE = File.expand_path('../../config/tmdb.yml', __FILE__)

  def self.fetch_id_from(url)
      url.scan(/tt\d{7}/).first || ''
  end

  def self.set_api_key
    Tmdb::Api.key(YAML.load_file(API_KEY_FILE))
  end
end