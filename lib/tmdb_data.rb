require_relative 'imdb_budgets'
require 'themoviedb-api'

module TMDBData
# module for fetching data using TMDB API
  BASE_PATH = File.expand_path('../../data/TMDBData/', __FILE__)
  DEFAULT_ID_FILE = File.join(BASE_PATH, 'id_list.yml')
  DEFAULT_TITLES_FILE = File.join(BASE_PATH, 'alt_titles.yml')
  API_KEY = '56f6e7d041053b8d2d29db60f6072e1b'

  def self.make_id_list(top_chart_url, file_name = DEFAULT_ID_FILE)
    Tmdb::Api.key(API_KEY)
    main_page = Nokogiri::HTML(WebHelper.cashed_get(top_chart_url), nil, 'UTF-8')

    id_list =
      main_page
      .css('td.titleColumn a')
      .map do |blok|
        imdb_id = IMDBBudgets.fetch_id_from(blok['href'])
        movie = Tmdb::Find.movie(imdb_id, external_source: 'imdb_id').first
        { id: movie.id, imdb_id: IMDBBudgets.fetch_id_from(blok['href']), name: blok.text }
      end
      .to_yaml
    
    FileUtils.mkdir_p BASE_PATH
    File.write(file_name, id_list)
  end

  def fetch_posters(id_list = DEFAULT_FILE_NAME)
    
  end

  def self.fetch_alt_titles(file_name, id_list = DEFAULT_ID_FILE)
    Tmdb::Api.key(API_KEY)
    contents = YAML.load_file(id_list)
    alt_titles = 
      contents.map do |data|
        id = data[:id]
        titles = Tmdb::Movie.alternative_titles(id).map { |t| t.title }
        { id: id, imdb_id: data[:imdb_id], titles: titles }
      end
      .to_yaml

    FileUtils.mkdir_p BASE_PATH
    File.write(file_name, alt_titles)
  end
end