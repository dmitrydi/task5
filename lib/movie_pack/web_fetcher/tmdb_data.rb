module MoviePack::WebFetcher
  module TMDBData
  # module for fetching data using TMDB API
    def self.make_id_list(top_chart_url, file_name = DEFAULT_ID_FILE)
      main_page = Nokogiri.HTML(WebHelper.cached_get(top_chart_url), nil, 'UTF-8')

      id_list =
        main_page
        .css('td.titleColumn a')
        .map do |blok|
          imdb_id =  MoviePack::WebFetcher.id_from(blok['href'])
          movie = Tmdb::Find.movie(imdb_id, external_source: 'imdb_id').first
          { id: movie.id, imdb_id: imdb_id, name: blok.text }
        end
        .to_yaml
    
      FileUtils.mkdir_p File.dirname(file_name)
      File.write(file_name, id_list)
    end

    private
    def self.set_api_key
      Tmdb::Api.key(YAML.load_file(API_KEY_FILE)) unless Tmdb::Api.params[:api_key]
    end

    class TMDBFetcher
      def initialize(
        id_file: DEFAULT_ID_FILE,
        posters_path: POSTERS_PATH,
        alt_titles_file: ALT_TITLES_FILE,
        budgets_file: DEFAULT_BUDGETS_FILE
      )
        @id_file = id_file
        @posters_path = posters_path
        @alt_titles_file = alt_titles_file
        @budgets_file = budgets_file
        @ids = ids_from_file(id_file)
        FileUtils.mkdir_p posters_path
        FileUtils.mkdir_p File.dirname(alt_titles_file)
        TMDBData.set_api_key
        Encoding.default_external = 'UTF-8'
        Encoding.default_internal = 'UTF-8'
      end

      attr_accessor :id_file, :posters_path, :alt_titles_file, :budgets_file
      attr_reader :ids

      def ids_from_file(id_file)
        TMDBData.make_id_list(TOP_250_URL, id_file) unless File.file?(id_file)
        contents = YAML.load_file(id_file)
        ids = contents.map { |d| d[:id] }
      end

      def fetch_posters_to_dir
        @ids.each do |id|
          fname = File.join(@posters_path, id.to_s + '.jpg')
          unless File.file?(fname)
            poster_url = BASE_IMAGE_URL + Tmdb::Movie.detail(id).poster_path
            File.open(fname, 'wb') { |f| f.write open(poster_url).read }
          end
        end
      end

      def fetch_alt_titles_to_file
        alt_titles = 
          @ids.map do |id|
            titles = Tmdb::Movie.alternative_titles(id).map { |t| t.title }
            { id: id, titles: titles }
          end
          .to_yaml
        File.write(@alt_titles_file, alt_titles)
      end

      def to_html(
        haml_template: DEFAULT_HAML_FILE,
        output_html: DEFAULT_HTML_FILE
      )
        check_data_files(@budgets_file, @alt_titles_file)
        id_data = YAML.load_file(@id_file)
        budgets_data = YAML.load_file(@budgets_file)
        alt_titles_data = YAML.load_file(@alt_titles_file)
        movies = id_data.map { |id_hash| data_from_id_hash(id_hash, budgets_data, alt_titles_data) }
        template = File.read(haml_template)
        html_data = Haml::Engine.new(template).render(Object.new, movies: movies)
        File.write(output_html, html_data)
      end

      def check_data_files(budgets_file, alt_titles_file)
        IMDBBudgets.to_file(file_name: budgets_file) unless File.file?(budgets_file)
        fetch_alt_titles_to_file unless File.file?(alt_titles_file)
      end

      def data_from_id_hash(id_hash, budgets_data, alt_titles_data)
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
    end
  end
end