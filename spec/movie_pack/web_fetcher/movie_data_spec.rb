require_relative 'spec_helper'

describe MovieData do
  describe '#fetch_id_from' do
    let(:film_url) { "http://www.imdb.com/title/tt0111161/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=2398042102&pf_rd_r=0A9F9F4SJA3EB5C1PPY6&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_1" }
    it { expect(MovieData.fetch_id_from(film_url)).to eq('tt0111161') }
  end
end