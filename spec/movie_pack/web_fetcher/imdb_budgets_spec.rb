require_relative 'spec_helper'

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
    let(:file_name) { File.join(DATA_PATH, IMDBBudgets::DEFAULT_NAME) }

    before(:example) do
      IMDBBudgets.to_file(url)
    end

    it { expect(File.exists?(file_name)).to be true }
  end
end