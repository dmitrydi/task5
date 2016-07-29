require 'rspec/its'
require_relative '../../lib/movie_data'
require 'webmock/rspec'
require 'vcr'

RSpec::Matchers.define_negated_matcher :not_have_requested, :have_requested

VCR.configure do |c|
  c.cassette_library_dir = 'vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

include MovieData