DATA = File.read('data.txt').split(?,).map(&:to_i)

def calc_xth x
    mem = DATA.each_with_index.to_h.transform_values(&:succ)
    (DATA.size...x).inject(DATA.last) do |last, turn|
        v = mem.fetch(last, turn)
        mem[last] = turn
        turn - v
    end
end

puts 'Part 1: %s' % calc_xth(2020)
puts 'Part 2: %s' % calc_xth(30000000)
