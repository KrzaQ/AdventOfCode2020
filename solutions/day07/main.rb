DATA = File.read('data.txt').split("\n")

xxx = DATA.map do |line|
    xx = line.split[0..1].join(' ')
    r = line.scan(/\d+ (\w+ \w+) bag/).map do |x|
        [x, xx].flatten
    end
    r
end.flatten(1).group_by(&:first).map do |k, v|
    [k, v.map(&:last)]
end.to_h

done = []
looking = ['shiny gold']

loop do
    if looking.size == 0
        break
    end
    to_add = xxx.fetch(looking.first, [])
    to_add
    looking |= to_add - done
    done.push looking.first
    looking = looking[1..-1]
end

p done.size - 1

xxx = DATA.map do |line|
    xx = line.split[0..1].join(' ')
    r = [xx, line.scan(/(\d+) (\w+ \w+) bag/)]
    r
end.to_h

count = 0
looking = [[1, 'shiny gold']]
loop do
    if looking.size == 0
        break
    end
    n, type = *looking.first
    exit if n > 1000000
    to_add = xxx.fetch(type, [])
    looking += to_add.map{ |m, t| [(m.to_i * n), t] }
    count += n
    looking = looking[1..-1]
end

p count - 1
