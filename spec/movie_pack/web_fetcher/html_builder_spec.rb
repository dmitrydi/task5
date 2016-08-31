require_relative 'spec_helper'

module MoviePack::WebFetcher
  describe HTMLBuilder do
    let(:top_chart_url) { TOP_250_URL }
    let(:haml_template) { DEFAULT_HAML_FILE }
    let(:output_html) { DEFAULT_HTML_FILE }
    let(:id_file) { DEFAULT_ID_FILE }
    let(:budgets_file) { DEFAULT_BUDGETS_FILE }
    let(:alt_titles_file)  { ALT_TITLES_FILE }
    let(:posters_path) { POSTERS_PATH }

    describe '#id_file_consistent?' do
      let(:id_file_consistent) { HTMLBuilder.id_file_consistent?(top_chart_url, id_file) }

      context 'when no id_file exist' do
        before(:example) { FileUtils.rm id_file, force: true }

        it { expect(id_file_consistent).to be false }
      end

      context 'id_file exists but [:imdb_id] records in id_file dont match in top_chart_url', :vcr => { :record => :new_episodes } do
        before(:example) do
          TMDBData.set_api_key
          TMDBData.make_id_list(top_chart_url, id_file)
          string = YAML.load_file(id_file)
          string.first[:imdb_id] = 'bad_data'
          File.write(id_file, string.to_yaml)
        end

        it { expect(id_file_consistent).to be false }
      end

      context 'id_file exists and data match top_chart_url', :vcr => { :record => :new_episodes } do
        before(:example) do
          TMDBData.set_api_key
          TMDBData.make_id_list(top_chart_url, id_file)
        end

        it { expect(id_file_consistent).to be true }
      end
    end

    describe '#check_data_files' do
      let(:check_files) do
        HTMLBuilder.check_data_files(
          top_chart_url,
          id_file,
          budgets_file,
          alt_titles_file,
          posters_path
        )
      end

      context 'when data in id_file inconsistent', :vcr => { :record => :new_episodes } do
        before(:example) do
          FileUtils.rm id_file, force: true
          FileUtils.rm_f Dir.glob("#{posters_path}/*")
        end

        it do
          expect(TMDBData).to receive(:make_id_list).with(top_chart_url, id_file).and_call_original
          expect(IMDBBudgets).to receive(:to_file).with(top_chart_url: top_chart_url, file_name: budgets_file).and_call_original
          expect(Tmdb::Movie).to receive(:detail).with(an_instance_of(Fixnum)).exactly(250).times.and_call_original
          expect(Tmdb::Movie).to receive(:alternative_titles).with(an_instance_of(Fixnum)).exactly(250).times.and_call_original
          check_files
        end
      end

      context 'when id_data OK but data files missing', :vcr => { :record => :new_episodes } do
        before(:example) do
          FileUtils.rm budgets_file, force: true
          FileUtils.rm alt_titles_file, force: true
        end

        it do
          expect(IMDBBudgets).to receive(:to_file).with(top_chart_url: top_chart_url, file_name: budgets_file).and_call_original
          expect(Tmdb::Movie).to receive(:alternative_titles).with(an_instance_of(Fixnum)).exactly(250).times.and_call_original
          check_files
        end
      end
    end

    describe '#build' , :vcr => { :record => :new_episodes } do
      it do
        expect(YAML).to receive(:load_file).at_least(1).times.with(id_file).and_call_original
        expect(YAML).to receive(:load_file).with(budgets_file).and_call_original
        expect(YAML).to receive(:load_file).with(alt_titles_file).and_call_original
        expect(Haml::Engine).to receive(:new).with(an_instance_of(String)).and_call_original
        HTMLBuilder.build
      end
    end
  end
end