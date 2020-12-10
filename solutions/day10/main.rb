DATA = File.read('data.txt').lines.map(&:to_i)
D = [0, DATA.max + 3] + DATA
G = D.sort.map{ |x| [x, D.select{ |y| (y-x).between?(1,3) } ] }.to_h

def find_path g, node
    return [node] if g[node].size == 0
    for x in g[node].sort
        r = find_path g, x
        return [node] + r if r
    end
    nil
end

def p1
    r = find_path(G, 0).each_cons(2).map{ |a, b| b - a }.tally
    r[1] * r[3]
end

def p2
    ways = {0 => 1}
    for x in D.sort
        for y in G.fetch(x, [])
            ways[y] = ways.fetch(y, 0) + ways[x]
        end
    end
    ways.to_a.sort.last.last
end

puts 'Part 1: %s' % p1
puts 'Part 2: %s' % p2
