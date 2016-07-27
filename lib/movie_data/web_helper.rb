module MovieData
  module WebHelper
  # module for getting and storing web-pages
    def self.cached_get(url)
      file_name = get_name_for(url)
      if File.exists?(file_name)
        File.read(file_name)
      else
        url_contents = open(url).read
        FileUtils.mkdir_p TMP_PATH
        File.write(file_name, url_contents)
        url_contents
      end
    end

    def self.get_name_for(url)
      File.join(TMP_PATH, url_to_filename(url))
    end

    def self.url_to_filename(url)
      MovieData.fetch_id_from(url) + '.html'
    end
  end
end

