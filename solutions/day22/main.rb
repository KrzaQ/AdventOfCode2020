DATA = File.read('data.txt').scan(/^\d+$/).map(&:to_i)

PLAYER1, PLAYER2 = DATA[0...DATA.size/2], DATA[DATA.size/2..-1]

def next_round p1, p2
    if p1[0] > p2[0]
        [ p1[1..-1] + [p1[0], p2[0]], p2[1..-1] ]
    else
        [ p1[1..-1], p2[1..-1] + [p2[0], p1[0]] ]
    end
end

def simulate_p1 p1, p2
    loop do
        p1, p2 = next_round p1, p2
        break if p1.size == 0 or p2.size == 0
    end
    p1.reverse.each.with_index(1).map{ _1 * _2 }.sum +
    p2.reverse.each.with_index(1).map{ _1 * _2 }.sum
end

PART1 = simulate_p1 PLAYER1.dup, PLAYER2.dup

require 'set'

def next_round_p2 p1, p2
    a, b = p1[0], p2[0]
    winner_p1 = nil
    if p1.size > a and p2.size > b
        s = simulate_p2 p1[1..a], p2[1..b]
        winner_p1 = s[:winner] == :p1
    else
        winner_p1 = p1[0] > p2[0]
    end

    if winner_p1
        [ :p1, p1[1..-1] + [p1[0], p2[0]], p2[1..-1] ]
    else
        [ :p2, p1[1..-1], p2[1..-1] + [p2[0], p1[0]] ]
    end
end

MEMO = {}

def simulate_p2 p1, p2
    orig_input = [p1.dup, p2.dup]
    if MEMO.include? orig_input
        return MEMO[orig_input]
    end
    done = Set.new

    winner = nil
    loop do
        if done.include? [p1, p2]
            winner = :p1
            break
        else
            done.add [p1.dup, p2.dup]
        end
        winner, p1, p2 = next_round_p2 p1, p2
        break if p1.size == 0 or p2.size == 0

    end
    x = {
        winner: winner,
        p1: p1,
        p2: p2,
    }
    MEMO[orig_input] = x
    x
end

def part2
    x = simulate_p2 PLAYER1, PLAYER2
    x[:p1].reverse.each.with_index(1).map{ _1 * _2 }.sum +
    x[:p2].reverse.each.with_index(1).map{ _1 * _2 }.sum
end

puts 'Part 1: %s' % PART1
puts 'Part 2: %s' % part2
