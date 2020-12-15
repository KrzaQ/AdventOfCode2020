DATA = File.read('data.txt').split(?,).map(&:to_i).freeze
MEM = DATA.each.with_index(1).to_h.freeze

def calc_xth x, mem = MEM.dup
    (DATA.size...x).inject(DATA.last) do |last, turn|
        turn - mem.fetch(last, turn).tap{ mem[last] = turn }
    end
end

puts 'Part 1: %s' % calc_xth(2020)
puts 'Part 2: %s' % calc_xth(30000000)
