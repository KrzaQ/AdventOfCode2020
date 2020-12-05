to_seat = ->(l) { l.strip.gsub(/./, %w(F B R L).zip(%w(0 1 1 0)).to_h).to_i(2) }
SEATS = File.read('data.txt').split.map{ |l| to_seat[l] }

PART1 = SEATS.max
PART2 = [*SEATS.min..SEATS.max] - SEATS

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
