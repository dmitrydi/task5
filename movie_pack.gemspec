Gem::Specification.new do |s|
  s.name        = 'movie_pack'
  s.version     = '1.0.0'
  s.date        = '2016-09-09'
  s.summary     = "Movie Pack"
  s.description = "Working with virtual cinema theatres"
  s.authors     = ["dmitrydi"]
  s.executable  = 'netflix_do.rb'
  s.license       = 'MIT'

  s.files       = Dir['lib/*.rb'] + Dir['lib/**/*.rb'] + 
                  Dir['bin/*'] + Dir['data/**/*.txt'] +
                  Dir['data/**/*.haml'] + Dir['spec/*.rb'] +
                  Dir['spec/**/*.rb'] + Dir['doc/*'] + Dir['doc/**/*'] + 
                  ['.gitignore']
  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'progress-bar'
  s.add_runtime_dependency 'rspec'
  s.add_runtime_dependency 'slop'
  s.add_runtime_dependency 'themoviedb-api'
  s.add_runtime_dependency 'vcr'
  s.add_runtime_dependency 'virtus'
  s.add_runtime_dependency 'webmock'
  s.add_development_dependency 'yard'
end