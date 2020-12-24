require 'set'
SUM = -> a, b { a.zip(b).map(&:sum) }
ADJ = [[0, 1, -1], [-1, 1, 0], [0, -1, 1], [1, -1, 0], [-1, 0, 1], [1, 0, -1]]
DIRS = ["se", "sw", "nw", "ne", "w", "e"].zip(ADJ).to_h
AROUND = -> point { ADJ.zip([point] * 6).map{ SUM[_1, _2] } }
DATA = File.read('data.txt').split.map do |l|
    l.scan(/se|sw|nw|ne|e|w/).map{ DIRS[_1] }.inject{ |t, n| SUM[t, n] }
end.tally.reject{ _2 % 2 == 0 }.to_h

def next_round blacks
    around = blacks.to_a.map{ |pt| AROUND[pt] }.flatten(1).uniq - blacks.to_a
    new_blacks = blacks.reject do |pt|
        c = AROUND[pt].count{ blacks.include? _1 }
        c == 0 or c > 2
    end + around.select do |pt|
        c = AROUND[pt].count{ blacks.include? _1 }
        c == 2
    end
    new_blacks.sort.uniq.to_set
end

puts 'Part 1: %s' % DATA.size
puts 'Part 2: %s' % 100.times.inject(DATA.keys){ next_round _1.to_set }.size
