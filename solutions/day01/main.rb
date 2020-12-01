#!/usr/bin/ruby

DATA = File.read('data.txt').split.map(&:to_i)

def find_values_by_sum data, sum, num_values = 1
    if num_values == 1
        r = data.find{ |x| x == sum }
        return [r] if r
    else
        data.each_index do |n|
            next if data[n] > sum
            ret = find_values_by_sum(data[(n+1)...-1], sum-data[n], num_values-1)
            return [data[n]] + ret if ret and ret.size > 0
        end
    end
    nil
end

puts 'Part 1: %s' % find_values_by_sum(DATA, 2020, 2).inject(:*)
puts 'Part 2: %s' % find_values_by_sum(DATA, 2020, 3).inject(:*)
