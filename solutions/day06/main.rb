DATA = File.read('data.txt').split("\n\n").map(&:split)
PART1 = DATA.map{ |g| g.map(&:chars).inject(:|).size }.sum
PART2 = DATA.map{ |g| g.map(&:chars).inject(:&).size }.sum

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
