def parse_seat line
    val = line.strip.gsub(/./, %w(F B R L).zip(%w(0 1 1 0)).to_h)
    val[0...7].to_i(2) * 8 + val[7...10].to_i(2)
end

SEATS = File.read('data.txt').split.map{ |l| parse_seat l }
PART1 = SEATS.max
PART2 = [*SEATS.min..SEATS.max] - SEATS

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
