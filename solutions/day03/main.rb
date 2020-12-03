DATA = File.read('data.txt')

SLOPES = [[1,1],[3,1],[5,1],[7,1],[1,2]]

def count_trees(right, down)
    arr = DATA.lines
    arr = (0...arr.length).step(down).map{ |n| arr[n] }
    arr.map(&:strip).each_with_index.map do |line, index|
        line[(index * right) % line.size]
    end.count('#')
end

PART1 = count_trees(3, 1)
PART2 = SLOPES.map{ |x| count_trees *x }.inject(:*)

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
