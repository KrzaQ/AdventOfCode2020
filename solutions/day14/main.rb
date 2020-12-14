DATA = File.read('data.txt').lines

def p1 mem = {}, mand = nil, mor = nil
    DATA.each do |l|
        case l
        when /mask = ([10X]+)/
            mask = $1
            mand = mask.gsub(?X, ?1).to_i(2)
            mor = mask.gsub(?X, ?0).to_i(2)
        when /mem\[(\d+)\] = (\d+)/
            addr, val = [$1, $2].map(&:to_i)
            mem[addr] = (val & mand) | mor
        end
    end
    mem.values.sum
end

def mask_permutation str, n, bits
    val = '%0*d' % [ bits, n.to_s(2).to_i ]
    val.chars.each{ |v| str = str.sub ?X, v }
    str
end

def p2 mem = {}, mask = nil, mask_xs = 0
    DATA.each do |l|
        case l
        when /mask = ([10X]+)/
            mask = $1
            mask_xs = mask.count(?X)
        when /mem\[(\d+)\] = (\d+)/
            addr, val = [$1, $2].map(&:to_i)
            iters = 2 ** mask_xs
            addr = addr & mask.gsub(?0, ?1).gsub(?X, ?0).to_i(2)
            iters.times.map{ |i| mask_permutation mask, i, mask_xs }
                .each{ |m| mem[addr | m.to_i(2)] = val }
        end
    end
    mem.values.sum
end

puts 'Part 1: %s' % p1
puts 'Part 2: %s' % p2
