require_relative '../../lib/imdb_budgets'
require 'rspec/its'

describe IMDBBudgets do
  describe '#budgets' do
    let(:url) { IMDBBudgets::TOP_250_URL }
    let(:budget_ary) { IMDBBudgets.fetch(url) }

    subject { budget_ary }
      its("class") { should eq(Array) }
      its("length") { should eq(250) }
  end
end