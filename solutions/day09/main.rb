DATA = File.read('data.txt').scan(/\d+/).map(&:to_i)

PART1 = DATA.each_cons(26).find do |*a, b|
    not a.permutation(2).find{ |l, r| l + r == b }
end.last

def p2 s = 0, e = 1
    r = DATA[s...e].sum
    r < PART1 ? p2(s, e+1) : r > PART1 ? p2(s+1, e) : [s, e]
end
PART2 = DATA[Range.new(*p2)].minmax.sum

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
