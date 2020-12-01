#!/usr/bin/ruby

data = DATA.readlines
#asteroid is visible if not a multiple of the co-ordinates of another asteroid?
#so like... from 0,0 then 1,1 blocks all n,n. no... 2,2 blocks 3,3 which isn't a multiple.
#more like... the angle is the same. the slope. x1-x2/(y1-y2). all asteroids with same slope (relatively) are on same path that only counts once

asteroids = []
data.each_with_index { |row, y|
    row.chars.each_with_index { |char, x|
        if char == '#'
            asteroids << [x, y]
        end
    }
}

p "#{asteroids.size} asteroids"

maxSeen = 0
bestStation = nil
bestSlopes = nil

asteroids.each { |station|
    #p "trying station at #{station}"
    slopes = asteroids.map { |asteroid|
        if asteroid != station
            dy = asteroid[1] - station[1]
            dx = asteroid[0] - station[0]
            if dy == 0
                dx > 0 ? "pos0" : "neg0"
            elsif dx == 0
                dy > 0 ? "posInf" : "negInf"
            else
                direction = dy > 0 ? 1 : -1
                [dx.to_f/dy, direction]
            end
        end
    }
    #p slopes
    #p "--------------"
    #p slopes.uniq
    seen = slopes.uniq.size - 1
    #p "#{seen} visible"
    if seen > maxSeen
        maxSeen = seen
        bestStation = station
        bestSlopes = slopes
    end
}
p maxSeen
p bestStation

#find 200th killed, clockwise from straight-up
#344 visible, so, less than one rotation.
#gonna have to keep track of where we're at
#also now I need co-ordinates when I find it
#if I can avoid truly deleting, I can use the index

killed = 0
#first kill a straight-up one, negInf
#yes, negative is up, this throws everything off :P
first = bestSlopes.index("negInf")
p "first #{asteroids[first]}"
if (first)
    killed += 1
end
#next is the most positive slope, direction 1
#this feels verrry inefficient
#so let's first find out how *many* uniques there are in that quadrant
q1 = bestSlopes.select { |slope|
    slope.is_a?(Array) && slope[1] == -1 && slope[0] < 0
}
killQ1 = q1.uniq.size
p "#{killQ1} in q1"
#next is pos0
pos0 = bestSlopes.index("pos0")
p "pos0 #{asteroids[pos0]}"
if (pos0)
    killed += 1
end
killed += killQ1

q2 = bestSlopes.select { |slope|
    slope.is_a?(Array) && slope[1] == 1 && slope[0] > 0
}
killQ2 = q2.uniq.size
killed += killQ2
#*pos*Inf
posInf = bestSlopes.index("posInf")
p "posInf #{asteroids[posInf]}"
if (posInf)
    killed += 1
end
p "#{killQ2} in q2, #{killed} overall"

q3 = bestSlopes.select { |slope|
    slope.is_a?(Array) && slope[1] == 1 && slope[0] < 0
}
killQ3 = q3.uniq.size
killed += killQ3

neg0 = bestSlopes.index("neg0")
p "neg0 #{asteroids[neg0]}"
if (neg0)
    killed += 1
end
p "#{killQ3} in q3, #{killed} overall"

q4 = bestSlopes.select { |slope|
    slope.is_a?(Array) && slope[1] == -1 && slope[0] > 0
}

#ok, q*4* is it! that is a biiig quadrant. 
#now, I have to count unique slopes in order, *and* map them to the right index
#which is hard when they have to be non-unique.
#I could grab everything with that slope and pick the nearest, that's ok
#also we don't need the direction when sorting

q4u = q4.uniq.map { |e| e[0] }
q4u.sort!
q4u.reverse!
p "first is #{q4u.first} last is #{q4u.last}"
#p q4u
#we want the smallest first, luckily
#no waiiit maybe not, because y is negative
#that does mean I misnamed my axes. whatevr.
#also it's supposed to be y/x not x/y, lol, at least it's consistent
#hope I'm not ob1 either. nth item is n-1
slope200 = q4u[199 - killed] #200 gives a bigger but still wrong answer
p "200th slope #{slope200}"

#now to find the indexes with that slope! aaand dir -1
minDistance = 99999
target = nil
bestSlopes.each_with_index { |slope, i|
    if slope.is_a?(Array) && slope[1] == -1 && slope[0] == slope200
        asteroid = asteroids[i]
        p "trying #{asteroid}"
        #ok, how far are you?
        #you're all the same slope so I can just use one axis
        dist = bestStation[0] - asteroid[0]
        if (dist < minDistance)
            minDistance = dist
            target = asteroid
        end
    end
}

p target[0] * 100 + target[1]


__END__
....#.....#.#...##..........#.......#......
.....#...####..##...#......#.........#.....
.#.#...#..........#.....#.##.......#...#..#
.#..#...........#..#..#.#.......####.....#.
##..#.................#...#..........##.##.
#..##.#...#.....##.#..#...#..#..#....#....#
##...#.............#.#..........#...#.....#
#.#..##.#.#..#.#...#.....#.#.............#.
...#..##....#........#.....................
##....###..#.#.......#...#..........#..#..#
....#.#....##...###......#......#...#......
.........#.#.....#..#........#..#..##..#...
....##...#..##...#.....##.#..#....#........
............#....######......##......#...#.
#...........##...#.#......#....#....#......
......#.....#.#....#...##.###.....#...#.#..
..#.....##..........#..........#...........
..#.#..#......#......#.....#...##.......##.
.#..#....##......#.............#...........
..##.#.....#.........#....###.........#..#.
...#....#...#.#.......#...#.#.....#........
...####........#...#....#....#........##..#
.#...........#.................#...#...#..#
#................#......#..#...........#..#
..#.#.......#...........#.#......#.........
....#............#.............#.####.#.#..
.....##....#..#...........###........#...#.
.#.....#...#.#...#..#..........#..#.#......
.#.##...#........#..#...##...#...#...#.#.#.
#.......#...#...###..#....#..#...#.........
.....#...##...#.###.#...##..........##.###.
..#.....#.##..#.....#..#.....#....#....#..#
.....#.....#..............####.#.........#.
..#..#.#..#.....#..........#..#....#....#..
#.....#.#......##.....#...#...#.......#.#..
..##.##...........#..........#.............
...#..##....#...##..##......#........#....#
.....#..........##.#.##..#....##..#........
.#...#...#......#..#.##.....#...#.....##...
...##.#....#...........####.#....#.#....#..
...#....#.#..#.........#.......#..#...##...
...##..............#......#................
........................#....##..#........#
