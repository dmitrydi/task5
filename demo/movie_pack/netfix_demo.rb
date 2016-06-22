require_relative '../../lib/movie_pack'

include MoviePack

netfix = Netfix.read
netfix.pay(3)

begin
  puts netfix.show(period: 'new')
rescue RuntimeError => err_run
  puts err_run.message
end

puts

begin
  puts netfix.show(period: 'modern')
rescue RuntimeError => err_run
  puts err_run.message
end

puts

begin
  puts netfix.show(period: 'classic')
rescue RuntimeError => err_run
  puts err_run.message
end

puts

netfix.pay(1.5)

begin
  puts netfix.show(period: 'classic')
rescue RuntimeError => err_run
  puts err_run.message
end

puts

begin
  puts netfix.price_for('The Cinderella')
rescue ArgumentError => err_arg
	puts err_arg.message
end
