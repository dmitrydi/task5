require 'rubygems'
require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open("http://www.imdb.com/chart/top?ref_=nv_mv_250_6"))
puts(page.class)
puts(page.text.class)
page.css('td.titleColumn a').each do |t|
  budget = Nokogiri::HTML(open('http://www.imdb.com/' + t['href']))
  .css('div.txt-block:contains("Budget:")').text.delete("\n").gsub(/\s+/, ' ').gsub('(estimated)', '')
  puts("#{t.text} #{budget}")
end