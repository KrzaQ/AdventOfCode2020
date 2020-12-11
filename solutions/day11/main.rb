DATA = File.read('data.txt').lines.map(&:strip)

WIDTH = DATA[0].size
HEIGTH = DATA.size

def indexes_around x, y
    xmin = [0, x-1].max
    xmax = [x+1, WIDTH-1].min
    
    ymin = [0, y-1].max
    ymax = [y+1, HEIGTH-1].min
    (xmin..xmax).to_a.map{ |x| [x].product((ymin..ymax).to_a) }.flatten(1)
        .reject{ |xx, yy| xx == x and yy == y }
end

def count_occupied_around data, x, y
    indexes_around(x, y).count{ |xx, yy| data[yy][xx] == '#' }
end

def next_iteration_p1 input
    ret = input.map(&:clone)
    (0...WIDTH).each do |x|
        (0...HEIGTH).each do |y|
            v = case input[y][x]
            when '.'
                '.'
            when 'L'
                if count_occupied_around(input, x, y) == 0
                    '#'
                else
                    'L'
                end
            when '#'
                if count_occupied_around(input, x, y) >= 4
                    'L'
                else
                    '#'
                end
            else
                raise '???'
            end
            ret[y][x] = v
        end
    end
    ret
end

def p1 data
    d = data
    x = 0
    loop do
        x += 1
        d_prim = next_iteration_p1 d
        # puts d_prim.join("\n")
        if d.join == d_prim.join
            d = d_prim
            break
        end
        d = d_prim
    end
    d.join.count('#')
end

def within x, y
    x >= 0 and x < WIDTH and y >= 0 and y < HEIGTH
end

directions = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [1, -1],
    [1, 0],
    [1, 1],
    [0, -1],
    [0, 1],
]

def find_next_seat direction, x, y
    xx, yy = [x, y].zip(direction).map(&:sum)
    while within xx, yy
        return [xx, yy] if DATA[yy][xx] == 'L'
        xx, yy = [xx, yy].zip(direction).map(&:sum)
    end
    nil
end

SEEK_MAP = {}

(0...WIDTH).each do |x|
    (0...HEIGTH).each do |y|
        next if DATA[y][x] == '.'
        s = directions.map{ |dir| find_next_seat dir, x, y }.select(&:itself)
        SEEK_MAP[[x, y]] = s
    end
end

def count_occupied_vis data, x, y
    SEEK_MAP[[x, y]].count{ |xx, yy| data[yy][xx] == '#' }
end

def next_iteration_p2 input
    ret = input.map(&:clone)
    (0...WIDTH).each do |x|
        (0...HEIGTH).each do |y|
            v = case input[y][x]
            when '.'
                '.'
            when 'L'
                if count_occupied_vis(input, x, y) == 0
                    '#'
                else
                    'L'
                end
            when '#'
                if count_occupied_vis(input, x, y) >= 5
                    'L'
                else
                    '#'
                end
            else
                raise '???'
            end
            ret[y][x] = v
        end
    end
    ret
end

def p2 data
    d = data
    x = 0
    loop do
        x += 1
        d_prim = next_iteration_p2 d
        # puts d_prim.join("\n")
        if d.join == d_prim.join
            d = d_prim
            break
        end
        d = d_prim
    end
    d.join.count('#')
end

PART1 = p1 DATA
PART2 = p2 DATA

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
