D = File.read('data.txt').scan(/\d+/).map(&:to_i)
P1 = D.each_cons(26).find{ |*a,b| !a.permutation(2).find{ |l, r| l+r==b } }.last
p2=->s,e{{1=>->{p2[s+1,e]},0=>->{[s,e]},-1=>->{p2[s,e+1]}}[D[s...e].sum<=>P1][]}
P2 = D[Range.new(*p2[0,1])].minmax.sum

puts 'Part 1: %s' % P1
puts 'Part 2: %s' % P2
