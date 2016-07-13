require_relative '../../lib/web_helper'
require 'rspec'

describe WebHelper do
	let(:url) { "http://www.imdb.com/title/tt0111161/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=2398042102&pf_rd_r=1WHNSFSC9ND0X52YFRAT&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_1" }
  let(:url2) { "http://www.imdb.com/title/tt0111161?pf_rd_m=A2FGELUUNOQJNL&" }

  describe '#parse_url' do
    it { expect(WebHelper.parse_url(url)).to eq('title_tt0111161.html') }
    it { expect(WebHelper.parse_url(url2)).to eq('title_tt0111161.html') }
  end

  describe '#file_create' do
    let(:file_name) { WebHelper.file_create(url) }

    after(:example) do
      File.delete(file_name)
    end

    it { expect(File.exists?(file_name)).to be true }
  end

end