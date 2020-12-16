_VALS, _YOUR, NEARBY = File.read('data.txt').split("\n\n")
RANGES = _VALS.scan(/([\w\s]+): (\d+)-(\d+) or (\d+)-(\d+)/)
    .map{ [_1.strip, Range.new(_2.to_i, _3.to_i), Range.new(_4.to_i, _5.to_i)] }
MY = _YOUR.scan(/\d+/).map(&:to_i)

def range_match r, n
    r[1].include? n or r[2].include? n
end

PART1 = NEARBY.scan(/\d+/)
    .map(&:to_i)
    .reject{ |n| RANGES.any?{ range_match _1, n } }
    .sum

def part2
    nearby = NEARBY.lines[1..-1].map{ |l| l.scan(/\d+/).map(&:to_i) }
    rule_column_matches = nearby.reject do |t|
        t.any?{ |val| RANGES.none?{ |r| range_match r, val } }
    end.transpose.each_with_index.map do |vals, col|
        rs = RANGES.each_with_index
            .reject{ |r,i| vals.any?{ not range_match r, _1 } }
            .map(&:last)
        [rs, col]
    end
    temp = rule_column_matches.map(&:dup)
    column_to_rule = {}
    rule_column_matches.size.times do
        temp = temp.sort_by{ |r,c| (r-column_to_rule.values).size }
        r, c = *temp.first
        column_to_rule[c] = (r - column_to_rule.values).first
        temp.shift
    end

    column_to_rule = column_to_rule.map{ _1.reverse }.sort.to_h
    (0..5).map{ column_to_rule[_1] }.map{ MY[_1] }.inject(:*)
end


puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % part2
