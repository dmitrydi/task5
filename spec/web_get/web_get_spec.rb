require_relative '../../lib/web_get'
require 'rspec/its'

describe WebGet do
  describe '#budgets' do
    let(:url) { WebGet::TOP_250_URL }
    let(:budget_ary) { WebGet.budgets(url) }

    subject { budget_ary }
      its("class") { should eq(Array) }
      its("length") { should eq(250) }
  end
end