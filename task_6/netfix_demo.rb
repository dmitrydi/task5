require_relative 'netfix'

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



