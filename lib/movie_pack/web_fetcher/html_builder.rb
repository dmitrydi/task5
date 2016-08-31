module MoviePack::WebFetcher
  module HTMLBuilder
  # module for building HTML  file from data files
    def self.build(
      top_chart_url: TOP_250_URL,
      haml_template: DEFAULT_HAML_FILE,
      output_html: DEFAULT_HTML_FILE,
      id_file: DEFAULT_ID_FILE,
      budgets_file: DEFAULT_BUDGETS_FILE,
      alt_titles_file: ALT_TITLES_FILE,
      posters_path: POSTERS_PATH
    )
      check_data_files(top_chart_url, id_file, budgets_file, alt_titles_file, posters_path)
      id_data = YAML.load_file(id_file)
      budgets_data = YAML.load_file(budgets_file)
      alt_titles_data = YAML.load_file(alt_titles_file)
      movies = id_data.map { |id_hash| data_from_id_hash(id_hash, budgets_data, alt_titles_data) }
      template = File.read(haml_template)
      html_data = Haml::Engine.new(template).render(Object.new, movies: movies)
      File.write(output_html, html_data)
    end

    def self.data_from_id_hash(id_hash, budgets_data, alt_titles_data)
      id = id_hash[:id]
      imdb_id = id_hash[:imdb_id]
      id = id_hash[:id]
      imdb_id = id_hash[:imdb_id]
      data = OpenStruct.new
      data.name = id_hash[:name]
      data.budget = budgets_data.find { |d| d[:imdb_id] == imdb_id } [:budget]
      data.alt_titles_ary = alt_titles_data.find { |d| d[:id] == id } [:titles]
      data.img_name = File.join(POSTERS_PATH, id.to_s) + '.jpg'
      data
    end

    def self.check_data_files(
      top_chart_url,
      id_file,
      budgets_file,
      alt_titles_file,
      posters_path
    )
      id_file_consistent = id_file_consistent?(top_chart_url, id_file)
      TMDBData.make_id_list(top_chart_url, id_file) unless id_file_consistent
      tmdb_instance = TMDBData::TMDBFetcher.new(
                        id_file: id_file,
                        posters_path: posters_path,
                        alt_titles_file: alt_titles_file,
                        budgets_file: budgets_file
                      )
      unless (File.file?(budgets_file) && id_file_consistent)
        IMDBBudgets.to_file(top_chart_url: top_chart_url, file_name: budgets_file)
      end
      tmdb_instance.fetch_posters_to_dir
      unless (File.file?(alt_titles_file) && id_file_consistent)
        tmdb_instance.fetch_alt_titles_to_file
      end
    end

    def self.id_file_consistent?(top_chart_url, id_file)
      if File.file?(id_file)
        main_page = Nokogiri.HTML(WebHelper.cached_get(top_chart_url), nil, 'UTF-8')
        ids_in_web = 
          main_page
          .css('td.titleColumn a')
          .map { |blok| MoviePack::WebFetcher.id_from(blok['href']) }
        ids_in_file = YAML.load_file(id_file).map { |id_hash| id_hash[:imdb_id] }
        ids_in_web.sort == ids_in_file.sort
      else
        false
      end
    end
  end
end
