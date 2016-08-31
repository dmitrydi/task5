require_relative 'spec_helper'

module MoviePack::WebFetcher

describe TMDBData do
  describe '#make_id_list', :vcr => { :record => :new_episodes } do
    before(:all) do
      TMDBData.set_api_key
    end

    let(:top_chart_url) { TOP_250_URL }
    let(:id_file) { DEFAULT_ID_FILE }
    let(:id_maker) { TMDBData.make_id_list(top_chart_url) }

    context 'when no top_chart_url file exists' do
      before(:example) do
        FileUtils.rm WebHelper.get_name_for(top_chart_url), :force => true
      end

      it 'goes to top_chart_url using WebHelper and writes page to disk' do
        expect(WebHelper).to receive(:open).with(top_chart_url).and_call_original
        expect(id_maker).to have_requested(:get, top_chart_url).times(1)
      end
    end

    context 'when top_chart_url file exists' do
      it 'takes top_chart_url file from disk' do
        expect(File).to receive(:open).with(an_instance_of(String), 'r').and_call_original
        expect(id_maker).to not_have_requested(:any, top_chart_url) 
      end
    end

    it 'uses Tmdb::Find to fetch movie ids' do
      expect(Tmdb::Find).to receive(:movie).with(/tt\d{7}/,  external_source: 'imdb_id').exactly(250).times.and_call_original
      expect(id_maker).to have_requested(:get, /.*api.themoviedb.org.*/).times(250)
    end

    it { expect(File.exists?(id_file)).to be true }
  end

  describe TMDBData::TMDBFetcher, :vcr => { :record => :new_episodes } do
    let(:tmdb_instance) { TMDBData::TMDBFetcher.new }

    describe '#initialize' do
      it { expect(tmdb_instance).to be_instance_of TMDBData::TMDBFetcher }
      it { expect(tmdb_instance).to have_attributes(:id_file => a_value, :posters_path => a_value, :alt_titles_file => a_value) }
      it { expect(tmdb_instance).to respond_to(:id_file, :posters_path, :alt_titles_file, :ids) } 
      it { expect(tmdb_instance.ids).to be_instance_of Array }
      it { expect(tmdb_instance.ids.length).to eq(250) }

      context 'when Api key is not set' do
        before(:example) { Tmdb::Api.key(nil) }

        it 'sets Api key from API_KEY_FILE' do
          expect(Tmdb::Api).to receive(:key).with(YAML.load_file(API_KEY_FILE)).and_call_original
          tmdb_instance
        end
      end

      context 'when no id_file' do
        before(:example) { FileUtils.rm DEFAULT_ID_FILE, :force => true }

        it 'goes to web using #make_id_list' do
          expect(TMDBData).to receive(:make_id_list).with(TOP_250_URL, DEFAULT_ID_FILE).and_call_original
          expect(tmdb_instance).to have_requested(:get, /.*api.themoviedb.org.*/).times(250)
        end
      end

      context 'when id_file exists' do
        it 'does not go to web' do
          expect(tmdb_instance).to not_have_requested(:any, /.*/)
        end
      end
    end

    describe '#fetch_posters_to_dir' do
      context 'when no posters' do
        before(:example) do
          FileUtils.rm_rf Dir.glob("#{tmdb_instance.posters_path}/*")
        end

        it 'goes to web to get posters and writes to HD' do
          expect(Tmdb::Movie).to receive(:detail).with(an_instance_of Fixnum).exactly(250).times.and_call_original
          expect(tmdb_instance.fetch_posters_to_dir). to have_requested(:get, /.*api.themoviedb.org.*/).times(250)
        end
      end

      context 'when all posters in place' do
        it { expect(tmdb_instance.fetch_posters_to_dir).to not_have_requested(:any, /.*/) }
      end
    end

    describe '#fetch_alt_titles_to_file' do
      it do
        expect(Tmdb::Movie).to receive(:alternative_titles).with(instance_of(Fixnum)).exactly(250).times.and_call_original
        expect(tmdb_instance.fetch_alt_titles_to_file).to have_requested(:get, /.*api.themoviedb.org.*/).times(250)
      end

      it do
        expect(File).to receive(:write).with(tmdb_instance.alt_titles_file, an_instance_of(String)).and_call_original
        tmdb_instance.fetch_alt_titles_to_file
      end
    end
=begin
    describe '#to_html' do
      it do
        expect(YAML).to receive(:load_file).with(tmdb_instance.id_file).and_call_original
        expect(YAML).to receive(:load_file).with(tmdb_instance.budgets_file).and_call_original
        expect(YAML).to receive(:load_file).with(tmdb_instance.alt_titles_file).and_call_original
        expect(File).to receive(:read).with(DEFAULT_HAML_FILE).and_call_original
        expect(Haml::Engine).to receive(:new).with(an_instance_of(String)).and_call_original
        expect(File).to receive(:write).with(DEFAULT_HTML_FILE, an_instance_of(String)).and_call_original
        tmdb_instance.to_html
      end
    end
=end
  end
end
end