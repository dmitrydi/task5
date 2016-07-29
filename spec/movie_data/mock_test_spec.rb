require_relative 'spec_helper'

describe TMDBData do
  describe 'make_id_list', :vcr => { :record => :new_episodes } do
    before(:example) do
        MovieData.set_api_key
        FileUtils.rm WebHelper.get_name_for(TOP_250_URL), :force => true
    end

    let(:page) { WebHelper.cached_get(TOP_250_URL) }

    it 'sends request to TOP_250_URL' do
      expect(Nokogiri).to receive(:HTML).with(instance_of(String), nil, 'UTF-8').and_call_original
      TMDBData.make_id_list(TOP_250_URL)
    end
  end
end