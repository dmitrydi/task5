require_relative 'spec_helper'

describe IMDBBudgets do
  let(:url) { TOP_250_URL }

  describe '#fetch' do
    let(:budget_ary) { IMDBBudgets.fetch(url) }

    subject { budget_ary }
      its("class") { should eq(Array) }
      its("length") { should eq(250) }
  end

  describe '#to_file' do
    let(:file_name) { File.join(DATA_PATH, IMDBBudgets::DEFAULT_NAME) }

    before(:example) do
      IMDBBudgets.to_file(url)
    end

    it { expect(File.exists?(file_name)).to be true }
  end
end