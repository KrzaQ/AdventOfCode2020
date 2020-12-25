PK1, PK2 = File.read('data.txt').split.map(&:to_i)
MOD = 20201227
n1, n2 = [nil, nil]

(1..).each do |n|
    v = 7.pow(n, MOD)
    if v == PK1
        n1 = n
    elsif v == PK2 
        n2 = n
    end
    break if n1 and n2
end

puts 'Part 1: %s' % PK1.pow(n2, MOD)
