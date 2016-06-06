require_relative '../netfix'
require_relative '../movie_classes'


describe Netfix do

  let(:netfix) { Netfix.read }

  it{ expect(netfix).to be_an_instance_of Netfix }

  it{ expect(netfix.filter(genre: 'comedy')).to be_an_instance_of Netfix }

  it{ expect(netfix.filter(genre: 'comedy')).to be_an_instance_of MovieCollection }


end