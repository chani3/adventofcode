#!/usr/bin/ruby
require_relative "../helpers"
data = Helpers.loadData

Active = '#'
Inactive = '.'
Cycles = 6
Offset = Cycles + 1
Buffer = Offset*2
Width = Buffer + data[0].size
Height = Buffer + data.size
Depth = Buffer + 1

def newPocketArray
  Array.new(Width) { Array.new(Height) { Array.new(Depth, Inactive) }}
end
pocket = newPocketArray
#p pocket
data.each_with_index { |line, i|
  line.chars.each_with_index { |char, j|
    #p "setting #{j+Offset} #{i+Offset} #{Offset} to #{char}"
    pocket[j+Offset][i+Offset][Offset] = char
    #p pocket[j+Offset][i+Offset][Offset]
  }
}
p pocket[9][14][7]

Directions = [-1, 0, 1]
Neighbours = Directions.product(Directions, Directions).reject { |a| a == [0,0,0] }
def invalid(pos)
  pos[0] < 0 or pos[1] < 0 or pos[2] < 0 or pos[0] >= Width or pos[1] >= Height or pos[2] >= Depth
end
def getState(pos, pocket)
  if invalid(pos)
    return Inactive
  end
  pocket[pos[0]][pos[1]][pos[2]]
end
def getNextState(pos, pocket)
  oldState = getState(pos, pocket)
  myNeighbours = Neighbours.map { |rel| [pos[0]+rel[0],pos[1]+rel[1],pos[2]+rel[2]] }
  sum = myNeighbours.sum { |npos|
    nState = getState(npos, pocket)
    nState == Active ? 1 : 0
  }
  if oldState == Active
    return (sum == 2 or sum == 3) ? Active : Inactive
  end
  return sum == 3 ? Active : Inactive
end

def sumPocket(pocket)
  pocket.sum { |sheet|
    sheet.sum { |line|
      line.sum { |point|
        point == Active ? 1 : 0
      }
    }
  }
end
p sumPocket(pocket)

6.times do
  nextPocket = newPocketArray
  (0..Width-1).each { |x|
    (0..Height-1).each { |y|
      (0..Depth-1).each { |z|
        nextPocket[x][y][z] = getNextState([x,y,z], pocket)
      }
    }
  }
  pocket = nextPocket
  p sumPocket(pocket)
end


__END__
......##
####.#..
.##....#
.##.#..#
........
.#.#.###
#.##....
####.#..
