DATA = File.read('data.txt')

ENTRIES = DATA.scan(/(\d+)-(\d+) (\w): (\w+)/)

PART1 = ENTRIES.count do |e|
    min, max, letter, password = *e
    c = password.count(letter) 
    c >= min.to_i and c <= max.to_i
end

PART2 = ENTRIES.count do |e|
    first, second, letter, password = *e
    f = password[first.to_i - 1] == letter
    s = password[second.to_i - 1] == letter
    f ^ s
end

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
