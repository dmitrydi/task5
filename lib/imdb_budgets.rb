require 'rubygems'
require 'nokogiri'
require 'open-uri'
require_relative 'web_helper'
require 'progress-bar'
require 'yaml'

module IMDBBudgets

  TOP_250_URL = 'http://www.imdb.com/chart/top?ref_=nv_mv_250_6'
  BASE_PATH = File.expand_path('../../data/IMDBBudgets/', __FILE__)
  DEFAULT_NAME = 'budgets.yml'

  class Nokogiri::HTML::Document
    def fetch_budget
      self
      .css('div.txt-block:contains("Budget:")')
      .text
      .delete("\n")
      .gsub(/\s+/, '')
      .gsub('(estimated)', '')
      .gsub('Budget:', '')
    end
  end

  def self.fetch_id_from(url)
    url.gsub(WebHelper::DOMAIN + "/title/", '')
       .gsub(/(\/\?|\?).*/, '')
  end

  def self.fetch(top_chart_url)
    main_page = Nokogiri::HTML(WebHelper.cashed_get(top_chart_url), nil, 'UTF-8')
    data_ary = []

    data_ary = 
      main_page.css('td.titleColumn a').map do |blok|
      film_url = WebHelper::DOMAIN + blok['href']
      film_page = Nokogiri::HTML(WebHelper.cashed_get(film_url))
      budget = film_page.fetch_budget
      budget = 'N/A' if budget.empty?
      {imdb_id: fetch_id_from(film_url), name: blok.text, budget: budget}
    end
  end

  def self.to_file(top_chart_url, name = nil)
    file_name = File.join(BASE_PATH, name || DEFAULT_NAME)
    contents = fetch(top_chart_url).to_yaml
    FileUtils.mkdir_p BASE_PATH
    File.write(file_name, contents)
  end
end