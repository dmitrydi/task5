require_relative '..\cinema'
require_relative '..\movie_classes'

RSpec.shared_examples "creates a collection of diff.movies" do |cinema|
  it{ expect(cinema).to be_an_instance_of Cinema }

  it{ expect(cinema.collection).to be_an_instance_of Array}

  it{ expect(cinema.collection).to all(be_an_instance_of(AncientMovie) | be_an_instance_of(ClassicMovie) | be_an_instance_of(ModernMovie) | be_an_instance_of(NewMovie))}
end
