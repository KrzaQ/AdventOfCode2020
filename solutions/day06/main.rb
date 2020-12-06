DATA = File.read('data.txt').split("\n\n").map(&:split)
solve = ->(op) { DATA.map{ |g| g.map(&:chars).inject(op).size }.sum }

puts 'Part 1: %s' % solve[:|]
puts 'Part 2: %s' % solve[:&]
