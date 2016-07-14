require 'rubygems'
require 'nokogiri'
require 'open-uri'
require_relative 'web_helper'
require 'progress-bar'

class WebGet < WebHelper

  TOP_250_URL = 'http://www.imdb.com/chart/top?ref_=nv_mv_250_6'

  class Nokogiri::HTML::Document
    def get_budget
      self
      .css('div.txt-block:contains("Budget:")')
      .text
      .delete("\n")
      .gsub(/\s+/, ' ')
      .gsub('(estimated)', '')
    end
  end

  def self.budgets(top_chart_url)
    pb = ProgressBar.new 250, "Start getting budgets"

    main_page = Nokogiri::HTML(self.cashed_get(top_chart_url))
    main_page.css('td.titleColumn a').map do |blok|
      film_url = WebHelper::SITE_STR + blok['href']
      film_page = Nokogiri::HTML(self.cashed_get(film_url))
      budget = film_page.get_budget
      [blok.text, budget]
      pb.i += 1
    end
  end
end