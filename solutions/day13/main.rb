require 'z3'
DATA = File.read('data.txt').lines.map(&:strip)

ready, *buses_with_x = *DATA.join(' ').scan(/(\d+|x)/).flatten.map(&:to_i)
buses = buses_with_x.select{ |x| x > 0 }
closest = buses.sort_by{ |b| b - (ready % b) }.first
buses_with_x = buses_with_x.each_with_index.filter_map{ |v, i| [v, i] if v > 0 }

def modinv2(a, m) # compute a^-1 mod m if possible
    raise "NO INVERSE - #{a} and #{m} not coprime" unless a.gcd(m) == 1
    return m if m == 1
    m0, inv, x0 = m, 1, 0
    while a > 1
        inv -= (a / m) * x0
        a, m = m, a % m
        inv, x0 = x0, inv
    end
    inv += m0 if inv < 0
    inv
end

def cr mods, rems
    max = mods.inject( :* )  # product of all moduli
    series = rems.zip(mods).map{ |r,m| (r * max * modinv2(max/m, m) / m) }
    series.inject( :+ ) % max
end

PART1 = (closest - ready % closest) * closest
PART2 = cr *buses_with_x.map{ |b,i| [b, (b - i) % b] }.transpose

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2

# original solution:
# wolframalpha the shit out of this
# puts buses_with_x.map{ |v, i| "((#{v} * z#{i}) - #{i})" }.join("=")
# e.g. ((13 * z0) - 0)=((41 * z3) - 3)=((37 * z7) - 7)=((659 * z13) - 13)=((19 * z32) - 32)=((23 * z36) - 36)=((29 * z42) - 42)=((409 * z44) - 44)=((17 * z61) - 61)
# https://www.wolframalpha.com/input/?i=%28%2813+*+z0%29+-+0%29%3D%28%2841+*+z3%29+-+3%29%3D%28%2837+*+z7%29+-+7%29%3D%28%28659+*+z13%29+-+13%29%3D%28%2819+*+z32%29+-+32%29%3D%28%2823+*+z36%29+-+36%29%3D%28%2829+*+z42%29+-+42%29%3D%28%28409+*+z44%29+-+44%29%3D%28%2817+*+z61%29+-+61%29
# use z0 for n = 0 (or any other zx with appropriate mod, but n = 0)
# p 72268479692421 * buses_with_x.dig(0, 0)

# PS: z3 is *so not the way to go*