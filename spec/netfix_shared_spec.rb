require_relative '..\lib\netfix'
require_relative '..\lib\movie_classes'

RSpec.shared_examples "creates a collection of diff.movies" do |netfix|
  it{ expect(netfix).to be_an_instance_of Netfix }

  it{ expect(netfix.collection).to be_an_instance_of Array}

  it{ expect(netfix.collection).to all(be_an_instance_of(AncientMovie) | be_an_instance_of(ClassicMovie) | be_an_instance_of(ModernMovie) | be_an_instance_of(NewMovie))}
end
