DATA = File.read('data.txt').lines.map do |l|
    xxx, yyy = l.split('(contains')
    [xxx.split, yyy.gsub(/[\)\s]/, '').split(',')]
end

ALLERGENS = DATA.map(&:last).flatten.sort.uniq

def find_causes allergen
    DATA.reject do |k, v|
        x = v & [allergen]
        x.size == 0
    end.map(&:first).inject do |t, n|
        t.sort & n.sort
    end
end

ALL_ALLERGENS = ALLERGENS.map{ find_causes _1 }.flatten.sort.uniq
PART1 = DATA.map(&:first).inject([]) do |t, n|
    t + (n - ALL_ALLERGENS)
end.size

def part2
    sure = {}
    temp = ALLERGENS.map{ [_1, find_causes(_1)] }
    loop do
        f, a = temp.find{ _2.size == 1 }
        sure[f] = a.first
        temp = temp.map{ [_1, _2-a] }.reject{ _1 == f }.reject{ _2.size == 0 }
        break if temp.size == 0
    end
    sure.to_a.sort_by(&:first).map(&:last).join(',')
end

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % part2
