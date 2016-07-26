require_relative '../../lib/tmdb_data'

describe TMDBData do
  describe '#make_id_list' do
    let(:top_chart_url) { IMDBBudgets::TOP_250_URL }
    let(:id_file) { TMDBData::DEFAULT_ID_FILE }

    before(:example) { TMDBData.make_id_list(top_chart_url) }
    
    it { expect(File.exists?(id_file)).to be true }
  end

  describe '#fetch_alt_titles' do
    let(:file_name) { TMDBData::DEFAULT_TITLES_FILE }

    before(:example) { TMDBData.fetch_alt_titles(file_name) }

    it { expect(File.exists?(file_name)).to be true }
  end
end