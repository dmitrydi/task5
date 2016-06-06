require_relative '../netfix'
require_relative '../movie'
require_relative '../movie_collection'
require_relative '../movie_to_show'
require_relative '../netfix'
require_relative '../theatre'

describe Theatre do
  before :each do
    @theatre = Theatre.read
  end

  it 'is expected to have ::collection and ::money attributes' do
    expect(@theatre).to have_attributes( :money => 0)
    expect(@theatre).to respond_to(:collection)
    expect(@theatre.collection).to be_an_instance_of Array
    expect(@theatre.collection).not_to be_empty
    expect(@theatre.collection.first).to be_an_instance_of MovieToShow
  end

  describe '#make_shortlist' do
    expect(@theatre.make_shortlist(""))

end