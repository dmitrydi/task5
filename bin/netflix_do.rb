require_relative '../lib/movie_pack'
require_relative '../lib/slop'

opts = Slop.parse do |o|
  o.integer '--pay', default: 0
  o.filters '--filters', delimiter: ';'
end

netflix = MoviePack::Netflix.read
netflix.pay(opts[:pay])
netflix.show(opts[:filters])