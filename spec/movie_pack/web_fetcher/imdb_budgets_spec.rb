require_relative 'spec_helper'

module MoviePack::WebFetcher
  describe IMDBBudgets do
    let(:url) { TOP_250_URL }

    describe '#fetch', :vcr do
      let(:fetch_budgets) { IMDBBudgets.fetch(url) }

      context 'when no files exist' do
        before(:example) do
          Dir.foreach(TMP_PATH) { |f| File.delete(File.join(TMP_PATH, f)) if f.include?('.html') }
        end

        it { expect(fetch_budgets).to have_requested(:get, /http:\/\/www.imdb.com.*/).times(251) }
      end

      context 'when temporary files already exist' do
        subject { fetch_budgets }
        it { is_expected.to not_have_requested(:any, /http:\/\/www.imdb.com.*/) }
        its("class") { should eq(Array) }
        its("length") { should eq(250) }
      end
    end

    describe '#to_file' do
      let(:file_name) { DEFAULT_BUDGETS_FILE }

      before(:example) do
        IMDBBudgets.to_file(top_chart_url: url)
      end

      it { expect(File.exists?(file_name)).to be true }
    end
  end
end