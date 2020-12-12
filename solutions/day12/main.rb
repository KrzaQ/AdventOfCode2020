DATA = File.read('data.txt').scan(/\w\d+/)

DIRS = {
    n: [0, 1],
    e: [1, 0],
    s: [0, -1],
    w: [-1, 0],
}

def next_state_p1 state, order
    case order
    when /([NSWE])(\d+)/
        d = $1.downcase.to_sym
        newxy = state[:xy].zip(DIRS[d].map{|x| x*$2.to_i }).map(&:sum)
        state.merge({
            xy: newxy
        })
    when /([LR])(\d+)/
        mod = $1 == ?L ? -1 : 1
        idx = mod * $2.to_i/90
        idx += DIRS.keys.index state[:direction]
        new_dir = (DIRS.keys * 10)[idx]
        state.merge({
            direction: new_dir
        })
    when /F(\d+)/
        newxy = state[:xy].zip(DIRS[state[:direction]].map{|x| x*$1.to_i }).map(&:sum)
        state.merge({
            xy: newxy
        })
    end
end

PART1 = DATA.inject({ xy: [0, 0], direction: :e }) do |t, c|
    next_state_p1 t, c
end[:xy].map(&:abs).sum

def next_state_p2 state, order
    case order
    when /([NSWE])(\d+)/
        d = $1.downcase.to_sym
        new_wp = state[:waypoint].zip(DIRS[d].map{|x| x*$2.to_i }).map(&:sum)
        state.merge({
            waypoint: new_wp
        })
    when /([LR])(\d+)/
        mod = $1 == ?L ? -1 : 1
        new_wp = state[:waypoint]
        ($2.to_i/90).times do
            new_wp = [ mod * new_wp[1], mod * -1 * new_wp[0] ]
        end
        state.merge({
            waypoint: new_wp
        })
    when /F(\d+)/
        newxy = state[:xy].zip(state[:waypoint].map{|x| x*$1.to_i }).map(&:sum)
        state.merge({
            xy: newxy
        })
    end
end

PART2 = DATA.inject({ xy: [0, 0], waypoint: [10, 1] }) do |t, c|
    next_state_p2 t, c
end[:xy].map(&:abs).sum

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % PART2
