require_relative '../lib/movie_pack'
require 'slop'

opts = Slop.parse do |o|
  o.integer '--pay', default: 0
  o.array '--filters', delimiter: ','
end


module MovieFilters
  def self.parse(ary)
    dummy_filter = 
      ary.map do |f|
        f1,f2 = f.split(':')
        { f1.to_sym => f2 }
      end
      .reduce(:merge)
    filter =
      convert_types(dummy_filter)
  end

  def self.convert_types(hash)
    attr_keys = MoviePack::REC_HEADERS
    movie = MoviePack::Movie.new(attr_keys.map { |k| [k, ''] }.to_h)
    ans = hash.inject({}) do |memo, (k, v)|
            val = convert_to(v, movie.send(k))
            memo.merge({k => val})
          end
  end

  def self.convert_to(val, example)
    case example
    when Fixnum
      val.to_i
    when Float
      val.to_f
    when String
      val.to_s
    when Array
      [val]
    else
      nil
    end
  end
end



puts MovieFilters.parse(opts[:filters])