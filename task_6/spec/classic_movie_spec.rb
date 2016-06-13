require_relative 'movies_shared_spec'
require_relative '../netfix.rb'
require 'csv'

describe ClassicMovie do

  period = ClassicMovie::PERIOD

  let(:host) {Netfix.read}
  let(:classic_movie) {make_movie(described_class)}
  let(:movie_with_host) {make_movie(described_class, host)}
  let(:movie_list) {host.films_by_producers[movie_with_host.producer].join(", ")}

  it_behaves_like "a movie with limited period and certain price", period, 'classic', 1.5

  describe '#to_s' do

  	context 'when initialized without @host' do
  	  it { expect(classic_movie.to_s).to eq("#{classic_movie.title} - classic movie, producer: #{classic_movie.producer} (really good one)") }
  	end

    context 'when initialized with @host' do
      it {expect(movie_list).to be_instance_of String }
      it {expect(movie_list.length).to be > 0 }
      it {expect(movie_with_host.to_s).to eq("#{movie_with_host.title} - classic movie, producer: #{movie_with_host.producer} (#{movie_list})")}
    end


  end

end