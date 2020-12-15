DATA = File.read('data.txt').split(?,).map(&:to_i)

def calc_xth x
    mem = DATA[0...-1].each_with_index.to_a.to_h
    last = DATA.last
    (DATA.size-1..x-2).each do |turn|
        v = mem[last]
        mem[last] = turn
        last = v ? turn - v : 0
    end
    last
end

puts 'Part 1: %s' % calc_xth(2020)
puts 'Part 2: %s' % calc_xth(30000000)
