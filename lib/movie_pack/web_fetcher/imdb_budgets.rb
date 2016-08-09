module MoviePack::WebFetcher
  module IMDBBudgets
  # module for gettimg film budgets from top-250 IMDB
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

    def self.fetch(top_chart_url)
      main_page = Nokogiri::HTML(WebHelper.cached_get(top_chart_url), nil, 'UTF-8')

      data_ary = 
        main_page
        .css('td.titleColumn a')
        .map do |blok|
          film_url = DOMAIN + blok['href']
          film_page = Nokogiri::HTML(WebHelper.cached_get(film_url))
          budget = film_page.fetch_budget
          budget = 'N/A' if budget.empty?
          {imdb_id: id_from(film_url), name: blok.text, budget: budget}
        end
    end

    def self.to_file(top_chart_url, name = nil)
      file_name = File.join(DATA_PATH, name || DEFAULT_NAME)
      contents = fetch(top_chart_url).to_yaml
      FileUtils.mkdir_p DATA_PATH
      File.write(file_name, contents)
    end
  end
end