DATA = File.read('data.txt').scan(/(...) ([+-]\d+)/)
    .map{ |k, v| [k, v.to_i] }

def run data
    visited = []
    idx = 0
    acc = 0
    infloop = false
    while idx != data.size do
        if visited.include? idx
            infloop = true
            break
        end
        visited.push idx
        op, val = data[idx]
        case op
        when 'jmp'
            idx += val
        when 'acc'
            acc += val
            idx += 1
        when 'nop'
            idx += 1
        end
    end
    [acc, infloop]
end

def fix_data idx
    swapped = DATA[idx].clone
    swapped[0] = swapped[0] == 'jmp' ? 'nop' : 'jmp'
    data = DATA[0...idx] + [swapped] + DATA[(idx+1)..-1]
end

PART1 = run(DATA).first
PART2 = DATA.each_with_index.reject do |d, i|
    d.first == 'acc'
end.map(&:last).find do |i|
    data = fix_data i
    r = run data
    !r.last
end.yield_self do |idx|
    run(fix_data idx).first
end

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
