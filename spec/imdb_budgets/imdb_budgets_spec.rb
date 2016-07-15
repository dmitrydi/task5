require_relative '../../lib/imdb_budgets'
require 'rspec/its'

describe IMDBBudgets do
  let(:url) { IMDBBudgets::TOP_250_URL }

  describe '#fetch_id_from' do
    let(:film_url) { "http://www.imdb.com/title/tt0111161/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=2398042102&pf_rd_r=0A9F9F4SJA3EB5C1PPY6&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_1" }
    it { expect(IMDBBudgets.fetch_id_from(film_url)).to eq('tt0111161') }
  end
  
  describe '#fetch' do
    let(:budget_ary) { IMDBBudgets.fetch(url) }

    subject { budget_ary }
      its("class") { should eq(Array) }
      its("length") { should eq(250) }
  end

  describe '#to_file' do
    let(:file_name) { File.join(IMDBBudgets::BASE_PATH, IMDBBudgets::DEFAULT_NAME) }

    before(:example) do
      IMDBBudgets.to_file(url)
    end

    it { expect(File.exists?(file_name)).to be true }
  end
end