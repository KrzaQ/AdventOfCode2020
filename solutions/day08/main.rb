DATA = File.read('data.txt').scan(/(...) ([+-]\d+)/).map{ |k, v| [k, v.to_i] }

def run data, visited = [], idx = 0, acc = 0
    while idx < data.size and not visited.include? idx do
        op, val = data[idx]
        visited.push idx
        switch = { 'jmp' => [val, 0], 'acc' => [1, val], 'nop' => [1, 0] }
        idx, acc = switch[op].zip([idx, acc]).map(&:sum)
    end
    [ acc, (idx < data.size) ]
end

PART1 = run(DATA).first
PART2 = DATA.each_with_index.reject{ |d, i| d.first == 'acc' }.map do |d, i|
    s = [ (%w(nop jmp) - [d.first]), d.last ].flatten
    run(DATA[0...i] + [s] + DATA[(i+1)..-1])
end.find{ |a, inf| not inf }.first

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
