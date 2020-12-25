PK1, PK2 = File.read('data.txt').split.map(&:to_i)
MOD = 20201227
PART1 = (1..).each.find{ v = 7.pow(_1, MOD); v == PK1 or v == PK2 }
    .yield_self{ (7.pow(_1, MOD) == PK1 ? PK2 : PK1).pow(_1, MOD) }
puts 'Part 1: %s' % PART1
