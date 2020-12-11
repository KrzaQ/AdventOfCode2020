D = File.read('data.txt').lines.map(&:strip); W = D[0].size; H = D.size;
DS = [-1,0,1].repeated_permutation(2).to_a - [[0,0]]
legit = ->x,y{x>=0&&y>=0&&x<W&&y<H}; s = ->a,b{a.zip(b).map(&:sum)}
fns = ->d,x,y{x,y=s[d,[x,y]];legit[x,y] ?D[y][x]==?L? [x,y]: fns[d,x,y]:nil}
S = [*0...W].product([*0...H]).map{|x,y|[[x,y],DS.filter_map{|d|fns[d,x,y]}]}.to_h
a = ->x,y{DS.zip([[x,y]]*8).filter_map{|a,b| s[a,b] if legit[*s[a,b]]}}
o = ->d,x,y{a[x,y].count{|x,y|d[y][x]==?#}};v = ->d,x,y{S[[x,y]].count{|x,y|d[y][x]==?#}}
iter = ->i,f{r=i.map &:dup;0.upto(W-1){|x|0.upto(H-1){|y|r[y][x]=f[i,x,y]}};r}
hlp = ->o,m{{?.=>->_{?.},?L=>->o{o==0??#:?L},?#=>->o{o>=m ? ?L:?#}}[o]}
fp1 = ->d,x,y{hlp[d[y][x],4][o[d,x,y]]}; fp2 = ->d,x,y{hlp[d[y][x],5][v[d,x,y]]};
run = ->d,f{dp=iter[d,f]; dp==d ? d.join.count(?#) : run[dp,f]}
puts 'Part 1: %s' % run[D,fp1]
puts 'Part 2: %s' % run[D,fp2]
