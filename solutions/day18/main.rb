require 'citrus'
DATA = File.read('data.txt').lines

Citrus.load 'part1.citrus'
Citrus.load 'part2.citrus'

def parse_line line, cls
    x = line
        .gsub(/[\(\)]/){" #{_1 == '(' ? ')' : '('} "}
        .split
        .reverse
        .join(' ')
    ex = cls.parse x
    ex.value
end

puts 'Part 1: %s' % DATA.map{ parse_line _1, Part1 }.sum
puts 'Part 2: %s' % DATA.map{ parse_line _1, Part2 }.sum
