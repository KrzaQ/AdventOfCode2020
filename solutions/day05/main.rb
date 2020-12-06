to_seat = -> l { l.gsub(/F|L/, '0').gsub(/B|R/, '1').to_i(2) }
SEATS = File.read('data.txt').split.map{ |l| to_seat[l] }

PART1 = SEATS.max
PART2 = [*SEATS.min..SEATS.max] - SEATS

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
