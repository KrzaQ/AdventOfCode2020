DATA = File.read('data.txt').lines.map(&:strip)
S = ->a,b{a.zip(b).map(&:sum)}
DIRECTIONS3 = [-1,0,1].repeated_permutation(3).to_a - [[0,0,0]]
DIRECTIONS4 = [-1,0,1].repeated_permutation(4).to_a - [[0,0,0,0]]

def legit_xyz x, y, z, data
    x >= 0 and y >= 0 and z >= 0 and
    x < data[0][0].size and
    y < data[0].size and
    z < data.size
end

def around_xyz x, y, z, data
    DIRECTIONS3.map{ S[[x,y,z], _1] }.reject do |xx,yy,zz|
        not legit_xyz xx, yy, zz, data
    end
end

def get_next_iter_field_xyz data
    x = data[0][0].size
    y = data[0].size
    z = data.size
    empty_row = '.' * (x+2)
    empty_layer = (y+2).times.map{ empty_row.dup }
    (z+2).times.map{ empty_layer.map(&:dup) }
end

def next_iter_xyz data
    next_data = get_next_iter_field_xyz data
    s_x = next_data[0][0].size
    s_y = next_data[0].size
    s_z = next_data.size
    for z in 0...s_z
        for y in 0...s_y
            for x in 0...s_x
                dx, dy, dz = x-1, y-1, z-1
                a = around_xyz dx, dy, dz, data
                c = a.map{ data[_3][_2][_1] }.count('#')

                prev = if legit_xyz dx, dy, dz, data
                    data[dz][dy][dx]
                else
                    '.'
                end

                next_data[z][y][x] = if prev == '#'
                    if c == 2 or c == 3
                        '#'
                    else
                        '.'
                    end
                else
                    if c == 3
                        '#'
                    else
                        '.'
                    end
                end
            end
        end
    end
    next_data
end

def legit_xyzw x, y, z, w, data
    x >= 0 and y >= 0 and z >= 0 and w >= 0 and
    x < data[0][0][0].size and
    y < data[0][0].size and
    z < data[0].size and
    w < data.size
end

def around_xyzw x, y, z, w, data
    DIRECTIONS4.map{ S[[x,y,z,w], _1] }.reject do |xx,yy,zz,ww|
        not legit_xyzw xx, yy, zz, ww, data
    end
end

def get_next_iter_field_xyzw data
    x = data[0][0][0].size
    y = data[0][0].size
    z = data[0].size
    w = data.size
    empty_row = '.' * (x+2)
    empty_layer = (y+2).times.map{ empty_row.dup }
    mkz = ->{ (z+2).times.map{ empty_layer.map(&:dup) } }
    (w+2).times.map{ mkz[] }
end

def next_iter_xyzw data
    next_data = get_next_iter_field_xyzw data
    s_x = next_data[0][0][0].size
    s_y = next_data[0][0].size
    s_z = next_data[0].size
    s_w = next_data.size
    for w in 0...s_w
        for z in 0...s_z
            for y in 0...s_y
                for x in 0...s_x
                    dx, dy, dz, dw = x-1, y-1, z-1, w-1
                    a = around_xyzw dx, dy, dz, dw, data
                    c = a.map{ data[_4][_3][_2][_1] }.count('#')

                    prev = if legit_xyzw dx, dy, dz, dw, data
                        data[dw][dz][dy][dx]
                    else
                        '.'
                    end

                    next_data[w][z][y][x] = if prev == '#'
                        if c == 2 or c == 3
                            '#'
                        else
                            '.'
                        end
                    else
                        if c == 3
                            '#'
                        else
                            '.'
                        end
                    end
                end
            end
        end
    end
    next_data
end

P1 = 6.times
    .inject([DATA]){ |s, _| next_iter_xyz s }
    .flatten
    .join
    .count('#')
P2 = 6.times
    .inject([[DATA]]){ |s, _| next_iter_xyzw s }
    .flatten
    .join
    .count('#')

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % part2
