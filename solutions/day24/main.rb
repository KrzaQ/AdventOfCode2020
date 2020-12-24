require 'set'
DATA = File.read('data.txt').split
SUM = ->a,b{a.zip(b).map(&:sum)}
DIRS = {
    "se" => [0, 1, -1],
    "sw" => [-1, 1, 0],
    "nw" => [0, -1, 1],
    "ne" => [1, -1, 0],
    "w" => [-1, 0, 1],
    "e" => [1, 0, -1],
}
def parse_line l
    l.scan(/se|sw|nw|ne|e|w/).map{ DIRS[_1] }
end

PART1 = DATA.map do |l|
    parse_line(l).inject{ |t, n| SUM[t, n] }
end.tally.reject{ _2 % 2 == 0}.size


def around point
    DIRS.values.zip([point] * 6).map{ SUM[_1, _2]}
end

def next_round blacks
    around = blacks.to_a.map{ |pt| around pt }.flatten(1).uniq - blacks.to_a

    new_blacks = blacks.reject do |pt|
        c = around(pt).count{ blacks.include? _1 }
        c == 0 or c > 2
    end
    
    new_blacks += around.select do |pt|
        c = around(pt).count{ blacks.include? _1 }
        c == 2
    end

    new_blacks.sort.uniq.to_set
end

PART2 = DATA.map do |l|
    parse_line(l).inject{ |t, n| SUM[t, n] }
end.tally.reject{ _2 % 2 == 0}.map(&:first).to_set.yield_self do |tiles|
    100.times do |n|
        tiles = next_round tiles.to_set
    end
    tiles.size
end

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
