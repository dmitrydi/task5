require_relative 'spec_helper'

describe TMDBData do
  before(:all) do
    MovieData.set_api_key
  end

  describe '#make_id_list', :vcr => { :record => :new_episodes } do
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




=begin
  describe '#fetch_posters' do
    let(:dir) { TMDBData::POSTERS_PATH }

    before(:example) { TMDBData.fetch_posters(dir) }

    it { expect(Dir[File.join(dir, '**', '*')].count { |file| File.file?(file) } ).to eq(250) }
  end

  describe '#fetch_alt_titles' do
    let(:file_name) { TMDBData::DEFAULT_TITLES_FILE }

    before(:example) { TMDBData.fetch_alt_titles(file_name) }

    it { expect(File.exists?(file_name)).to be true }
  end
=end

end