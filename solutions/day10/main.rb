D = File.read('data.txt').lines.map(&:to_i).yield_self{ |x| [x.max+3,0]+x }.sort
G = D.map{ |x| [x, D.select{ |y| (y-x).between?(1,3) }.sort ] }.to_h
P1 = D.each_cons(2).map{ |a, b| b - a }.tally.yield_self{ |x| x[3] * x[1] }
p2 = -> w { D.each{|x| (G[x]||[]).each{|y| w[y]=w[y].to_i+w[x] } }; w.max.last }

puts 'Part 1: %s' % P1
puts 'Part 2: %s' % p2[{0 => 1}]
