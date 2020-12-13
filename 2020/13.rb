#!/usr/bin/ruby
require_relative "../helpers"
data = Helpers.loadData

startTime = data[0].to_i
buses = data[1].split(',').select { |s| s != "x" }.map(&:to_i)
nextTimes = buses.map { |id|
  prevBus = startTime % id
  prevBus == 0 ? 0 : id - prevBus
}

p startTime
p buses
p nextTimes

minTime = nextTimes.min
id = buses[nextTimes.index(minTime)]
p minTime * id

busTiming = []
data[1].split(',').each_with_index { |s, i|
  if s != "x"
    busTiming << {:id => s.to_i, :time => i, :target => (-i % s.to_i) }
  end
}
p busTiming

#x=b1n1-t1=b2n2-t2=...
#assuming t1=0, b2n2-t2)%b1=0
#(b2n2-t2+t3)%b3=0 etc
#(b1n1+tX)%bX=0
#b1n1%bX=-tX%bX

bus0 = busTiming[0][:id]
#busTiming[1..-1].each { |bus|
#  n=1
#  b = bus[:id]
#  target = bus[:time] % b
#  p bus
#  while (b*n)%bus0 != target
#    n += 1
#  end
#  p n
#  p b*n - bus[:time]
#}

#slow version
bt1 = busTiming[1..-1]
def invalid(x, busTiming)
  busTiming.each { |bus|
    if x%bus[:id] != bus[:target]
      return true
    end
  }
  return false
end
start = 100000000000000
n= (start / bus0).floor
while n*bus0 < start
  n+=1
end
p "starting at n #{n} ans #{n*bus0}"
while invalid(n*bus0, bt1)
  n += 1
end
p n*bus0

__END__
1000677
29,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,661,x,x,x,x,x,x,x,x,x,x,x,x,13,17,x,x,x,x,x,x,x,x,23,x,x,x,x,x,x,x,521,x,x,x,x,x,37,x,x,x,x,x,x,x,x,x,x,x,x,19
