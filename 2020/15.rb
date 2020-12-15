#!/usr/bin/ruby
require_relative "../helpers"
data = Helpers.loadData

seed = data[0].split(',').map(&:to_i)
ages = {}
lastTurn = {}

seed.each_with_index { |num, i|
  p num
  ages[num] = 0
  lastTurn[num] = i+1
}
turn = seed.size + 1
last = seed[-1]

#turn 7
loop do
  num = ages[last]
  #p num
  if lastTurn.include?(num)
    ages[num] = turn - lastTurn[num]
  else
    ages[num] = 0
  end
  last = num
  lastTurn[num] = turn
  if turn == 2020
    p num
    break
  end
  turn += 1
end

__END__
15,12,0,14,3,1
