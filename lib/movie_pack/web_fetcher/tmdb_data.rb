module MoviePack::WebFetcher
  module TMDBData
  # module for fetching data using TMDB API
    def self.make_id_list(top_chart_url, file_name = DEFAULT_ID_FILE)
      Encoding.default_external = 'UTF-8'
      Encoding.default_internal = 'UTF-8'
      
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
    end
  end
end