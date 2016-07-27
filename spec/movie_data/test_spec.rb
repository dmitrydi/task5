require 'webmock/rspec'
require_relative '../../lib/test'
require_relative 'vcr_setup'

describe Test do
  describe '#fetch_page', :vcr do
    let(:url) { Test::URL }

    it { expect(Test.fetch_page).to have_requested(:get, url) }
  end
end