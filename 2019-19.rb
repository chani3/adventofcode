#!/usr/bin/ruby
require_relative "./intcode"

data = nil
if ARGV.length > 0
    filename = ARGV[0]
    File.open(filename, "r") { |file|
        data = file.readlines
    }
else
    data = DATA.readlines
end

stationary = 0
pulled = 1
map = Array.new(50) { Array.new(50, 2) }

tileDisplay = ['.', '#', '?']
runner = IntCodeInteractive.new(data[0], nil, tileDisplay)
runner.run { |inQ, outQ|
    if map[0][0] != 2
        #time to count the beam spots
        beamSize = map.sum(0) { |row|
            row.sum(0) { |tile| tile == pulled ? 1 : 0 }
        }
        p "#{beamSize} points"
        next false
    end
    (0..49).each { |y|
        (0..49).each { |x|
            inQ << x
            inQ << y
            status = outQ.pop
            #p "#{x}, #{y} is #{status}"
            map[y][x] = status
            exitFlag = outQ.pop
            if exitFlag != "!exit"
                p "something went very wrong"
            end
            runner.reboot
            #map[nextPos.dup] = status
        }
    }
    map
}

__END__
109,424,203,1,21101,11,0,0,1106,0,282,21101,18,0,0,1106,0,259,1202,1,1,221,203,1,21102,31,1,0,1105,1,282,21101,0,38,0,1106,0,259,21002,23,1,2,22102,1,1,3,21102,1,1,1,21102,57,1,0,1106,0,303,2102,1,1,222,21002,221,1,3,20102,1,221,2,21102,1,259,1,21102,1,80,0,1105,1,225,21102,105,1,2,21102,91,1,0,1105,1,303,1202,1,1,223,20102,1,222,4,21102,259,1,3,21101,225,0,2,21101,225,0,1,21102,118,1,0,1106,0,225,20101,0,222,3,21101,157,0,2,21102,133,1,0,1106,0,303,21202,1,-1,1,22001,223,1,1,21102,1,148,0,1105,1,259,2101,0,1,223,20101,0,221,4,20101,0,222,3,21102,21,1,2,1001,132,-2,224,1002,224,2,224,1001,224,3,224,1002,132,-1,132,1,224,132,224,21001,224,1,1,21102,195,1,0,105,1,108,20207,1,223,2,20101,0,23,1,21102,-1,1,3,21101,0,214,0,1106,0,303,22101,1,1,1,204,1,99,0,0,0,0,109,5,1201,-4,0,249,21202,-3,1,1,21202,-2,1,2,22102,1,-1,3,21101,0,250,0,1106,0,225,22101,0,1,-4,109,-5,2106,0,0,109,3,22107,0,-2,-1,21202,-1,2,-1,21201,-1,-1,-1,22202,-1,-2,-2,109,-3,2105,1,0,109,3,21207,-2,0,-1,1206,-1,294,104,0,99,22102,1,-2,-2,109,-3,2106,0,0,109,5,22207,-3,-4,-1,1206,-1,346,22201,-4,-3,-4,21202,-3,-1,-1,22201,-4,-1,2,21202,2,-1,-1,22201,-4,-1,1,21201,-2,0,3,21101,0,343,0,1105,1,303,1105,1,415,22207,-2,-3,-1,1206,-1,387,22201,-3,-2,-3,21202,-2,-1,-1,22201,-3,-1,3,21202,3,-1,-1,22201,-3,-1,2,21201,-4,0,1,21102,384,1,0,1106,0,303,1106,0,415,21202,-4,-1,-4,22201,-4,-3,-4,22202,-3,-2,-2,22202,-2,-4,-4,22202,-3,-2,-3,21202,-4,-1,-2,22201,-3,-2,1,21201,1,0,-4,109,-5,2105,1,0
