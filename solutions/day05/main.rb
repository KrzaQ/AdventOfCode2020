def parse_seat line
    val = line.strip.gsub(/./, %w(F B R L).zip(%w(0 1 1 0)).to_h)
    [ val[0...7].to_i(2), val[7...10].to_i(2) ]
end

SEATS = File.read('data.txt').split.map{ |l| parse_seat l }

PART1 = SEATS.map{ |a, b| a * 8 + b }.max
PART2 = SEATS.map{ |a, b| a * 8 + b }.sort.each_cons(2).find do |a, b|
    b - a == 2
end.sum / 2

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
