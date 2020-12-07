DATA = File.read('data.txt').split("\n").map do |line|
    key = line.split[0..1].join(' ')
    values = line.scan(/(\d)+ (\w+ \w+) bag/).map{ |n, t| [key, [n.to_i, t]] }
end.flatten(1)

P1D = DATA.group_by{ |k, v| v.last }.map{ |k, v| [k, v.map(&:first)] }.to_h
p1 = -> k { P1D.fetch(k, []).map{ |x| p1[x] }.flatten.uniq + [k] }
P2D = DATA.group_by(&:first).map{ |k, v| [k, v.map(&:last)] }.to_h
p2 = -> k, n { P2D.fetch(k, []).map{ |k, v| p2[v, n*k] }.sum + n }

PART1 = p1['shiny gold'].size - 1
PART2 = p2['shiny gold', 1] - 1

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
