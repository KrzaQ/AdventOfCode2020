DATA = File.read('data.txt').split("\n\n").map do |tile|
    name, *rest = tile.lines
    [ name.scan(/\d+/).first.to_i, rest.map{ _1.strip.chars } ]
end.to_h

def flip_h img
    img.map(&:reverse)
end

def flip_v img
    img.reverse.map(&:dup)
end

def rot img, n = 1
    if n == 1
        img.map(&:chars).transpose.map{ _1.join.reverse }
    else
        rot rot(img), ((n - 1) % 4)
    end
end

def make_edges tile, f
    d = f[DATA[tile].map(&:join)]
    {
        tile: tile,
        top: d[0],
        down: d[-1],
        left: d.map(&:chars).transpose[0].join,
        right: d.map(&:chars).transpose[-1].join,
    }
end

x = DATA.map do |t, d|
    top = d[0].join
    down = d[-1].join
    left = d.transpose[0].join
    right = d.transpose[-1].join
    
    {
        "#{t}-id" => make_edges(t, -> t { t }),
        "#{t}-r90" => make_edges(t, -> t { rot t }),
        "#{t}-r180" => make_edges(t, -> t { rot t, 2 }),
        "#{t}-r270" => make_edges(t, -> t { rot t, 3 }),
        "#{t}-fh" => make_edges(t, -> t { flip_h t }),
        "#{t}-fv" => make_edges(t, -> t { flip_v t }),
        "#{t}-r90-fh" => make_edges(t, -> t { flip_h rot t }),
        "#{t}-r90-fv" => make_edges(t, -> t { flip_v rot t }),
    }.to_a
end.flatten(1)

def match_tiles a, b
    if a[:top] == b[:down]
        :top
    elsif a[:down] == b[:top]
        :down
    elsif a[:left] == b[:right]
        :left
    elsif a[:right] == b[:left]
        :right
    else
        nil
    end
end

mapping = x.map do |t, obj|
    r = x.reject{ |_, a| a[:tile] == obj[:tile] }
        .map{ |ot, oobj| [ot, match_tiles(obj, oobj)] }
        .select(&:last)
        .map(&:reverse)
        .to_h
    [t, r]
end.reject{ |k, v| v.size < 2 }.to_h

def graph_size tile, mapping
    return 0 if tile[1].size < 4

    done = []
    todo = tile[1].map(&:last)
    loop do
        new_todo = todo.map{ |t| mapping.fetch(t, []).map(&:last) }.flatten.uniq
        done += todo
        done = done.sort.uniq
        todo = new_todo - done
        break if todo.size == 0
    end
    done.size
end

middle = mapping.select{ |_, v| v.size == 4 }
    .sort_by{ |k, v| graph_size [k, v], mapping }.last

def follow k, dirs, mapping
    next_item = dirs.map{ [_1, k[1][_1], mapping[k[1][_1]]] }
    next_item.select{ |a,b,c| b and c }.first
end

def get_corner k, dirs, mapping
    id = k[0]
    loop do
        x, next_id, y = follow [id, mapping[id]], dirs, mapping
        break unless next_id
        id = next_id
    end
    id
end

a = get_corner middle, [:left, :top], mapping
b = get_corner middle, [:left, :down,], mapping
c = get_corner middle, [:right, :top], mapping
d = get_corner middle, [:right, :down], mapping

PART1 = [a,b,c,d].map{ _1.scan(/\d+/)[0].to_i }.inject(:*)

def get_part part
    part =~ /(\d+)-(.+)/
    id, mut = $1, $2
    d = DATA[id.to_i].map(&:join)
    part = case mut
    when 'id'
        d
    when 'r90'
        rot d
    when 'r180'
        rot d, 2
    when 'r270'
        rot d, 3
    when 'fv'
        flip_v d
    when 'fh'
        flip_h d
    when 'r90-fh'
        flip_h rot(d)
    when 'r90-fv'
        flip_v rot(d)
    else
        raise "wtf"
    end
    part[1...-1].map{ _1[1...-1] }
end

def make_map top_left_corner, mapping
    make_row = lambda do |left|
        ret = []
        loop do
            ret << get_part(left)
            left = mapping[left][:right]
            break unless left
        end
        ret
    end

    ret = []
    top = top_left_corner
    loop do
        ret << make_row[top]
        top = mapping[top][:down]
        break unless top
    end
    ret.map do |row|
        row.map{ _1.map(&:chars).transpose }.flatten(1).transpose.map(&:join)
    end.flatten
end

MONSTER = <<SEA_MONSTER
                  #
#    ##    ##    ###
 #  #  #  #  #  #
SEA_MONSTER

MONSTER_IDX = MONSTER.lines.each_with_index.map do |l, y|
    xs = l.chars.each_with_index.filter_map{  _2 if _1 == '#' }
    xs.zip([y] * xs.size)
end.flatten(1)

def find_monsters_impl img
    (0...img.size-2).each do |y|
        (0...img[y].size-19).each do |x|
            a = MONSTER_IDX.map{ |dx, dy| img[y+dy][x+dx] }.all?{ _1 == '#' }
            if a
                # puts "..."
                MONSTER_IDX.each{ |dx, dy| img[y+dy][x+dx] = 'O' }
            end
        end
    end
    img
end

def find_monsters img
    [
        ->{ img },
        ->{ rot img },
        ->{ rot img, 2 },
        ->{ rot img, 3 },
        ->{ flip_h img },
        ->{ flip_v img },
        ->{ flip_h rot img, 1 },
        ->{ flip_v rot img, 1 },
    ].map do |f|
        find_monsters_impl(f[]).join.count('#')
    end
end

PART2 = find_monsters(make_map a, mapping).min

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
