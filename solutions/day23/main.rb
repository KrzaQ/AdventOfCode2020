DATA = File.read('data.txt').chars.map(&:to_i)

def next_round arr
    s = arr.size
    tc = arr[1...4]
    arr = arr[0...1] + arr[4..-1]
    current = (1..4).map do |n|
        (arr[0] - n - 1) % s + 1
    end.reject do |v|
        tc.include? v
    end
    
    loop do
        v = current.shift
        i = arr.find_index{ _1 == v }
        if i
            current = i
            break
        end
    end
    arr.insert current+1, tc
    arr.flatten.rotate
end

def part1
    x = DATA
    100.times do
        x = next_round x
    end
    x = x.rotate x.find_index{ _1 == 1}
    x[1..-1].join
end

puts 'Part 1: %s' % part1
