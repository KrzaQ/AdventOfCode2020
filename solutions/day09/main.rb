DATA = File.read('data.txt').scan(/\d+/).map(&:to_i)

PART1 = DATA.each_cons(26).find do |a|
    r = a[0...25].product(a[0...25]).find do |l, r|
        l != r and a.last == l + r
    end
    not r
end.last

PART2 = (2...DATA.find_index(PART1)).map do |n|
    DATA[0...DATA.find_index(PART1)].each_cons(n).find do |a|
        a.sum == PART1
    end
end.select(&:itself).first.minmax.sum

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
