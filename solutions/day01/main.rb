#!/usr/bin/ruby

DATA = File.read('data.txt').split.map(&:to_i)

def part1 data
    DATA.each do |n|
        DATA.each do |m|
            return [m, n] if n + m == 2020
        end
    end
end

def part2 data
    DATA.each do |n|
        DATA.each do |m|
            DATA.each do |o|
                return [m, n, o] if n + m +o == 2020
            end
        end
    end
end


puts 'Part 1: %s' % part1(DATA).inject(:*)
puts 'Part 2: %s' % part2(DATA).inject(:*)
