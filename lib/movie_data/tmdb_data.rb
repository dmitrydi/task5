
module MovieData
  module TMDBData
  # module for fetching data using TMDB API
    def self.make_id_list(top_chart_url, file_name = DEFAULT_ID_FILE)
      main_page = Nokogiri.HTML(WebHelper.cached_get(top_chart_url), nil, 'UTF-8')

      id_list =
        main_page
        .css('td.titleColumn a')
        .map do |blok|
          imdb_id = MovieData.fetch_id_from(blok['href'])
          movie = Tmdb::Find.movie(imdb_id, external_source: 'imdb_id').first
          { id: movie.id, imdb_id: imdb_id, name: blok.text }
        end
        .to_yaml
    
      FileUtils.mkdir_p DATA_PATH
      File.write(file_name, id_list)
    end

    def self.check_id_list(id_list, top_chart_url)
      make_id_list(top_chart_url, id_list) unless File.file?(id_list)
    end


    def self.fetch_posters(dir, id_list = DEFAULT_ID_FILE, top_chart_url = TOP_250_URL)
      check_id_list(id_list, top_chart_url)
      contents = YAML.load_file(id_list)
      FileUtils.mkdir_p dir

      contents.each do |data|
        id = data[:id]
        fname = File.join(dir, id.to_s + '.jpg')
        unless File.file?(fname)
          poster_url = BASE_IMAGE_URL + Tmdb::Movie.detail(id).poster_path
          File.open(fname, 'wb') { |f| f.write open(poster_url).read }
        end
      end
    end

    def self.fetch_alt_titles(file_name, id_list = DEFAULT_ID_FILE, top_chart_url = TOP_250_URL)
      check_id_list(id_list, top_chart_url)
      contents = YAML.load_file(id_list)
      alt_titles = 
        contents.map do |data|
          id = data[:id]
          titles = Tmdb::Movie.alternative_titles(id).map { |t| t.title }
          { id: id, imdb_id: data[:imdb_id], titles: titles }
        end
        .to_yaml

      FileUtils.mkdir_p DATA_PATH
      File.write(file_name, alt_titles)
    end
  end
end