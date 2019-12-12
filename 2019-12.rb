#!/usr/bin/ruby

data = DATA.readlines
moons = []
data.each { |line|
    pos = []
    #parse that shit
    line.scan(/(-?\d+)/) { |m|
        pos << m[0].to_i
    }
    p "pos #{pos}"

    vel = [0,0,0]
    moon = { pos: pos, vel: vel }
    moons << moon
}

def applyG(moonA, moonB)
    #p moonA
    velA = moonA[:vel]
    velB = moonB[:vel]
    #pairwise. each axis of v gets +-1 to make them closer.
    #unless they're exactly aligned.
    velA.each_index { |i|
        if moonA[:pos][i] > moonB[:pos][i]
            velA[i] -=1
            velB[i] +=1
        elsif moonA[:pos][i] < moonB[:pos][i]
            velA[i] +=1
            velB[i] -=1
        end
    }
    #p moonA
end

def applyV(moon)
    #simple addition
    moon[:pos].each_index { |i| moon[:pos][i] += moon[:vel][i] }
end

def energyOf(moon)
    potential = moon[:pos].sum { |e| e.abs }
    kinetic = moon[:vel].sum { |e| e.abs }
    return potential * kinetic
end

def tick(moons)
    #apply g to v
    moons.repeated_combination(2) { |pair| applyG(pair[0], pair[1]) }
    #apply v to p
    moons.each { |moon| applyV(moon) }
end

1000.times { tick(moons) }
p moons.sum { |e| energyOf(e) }

__END__
<x=14, y=4, z=5>
<x=12, y=10, z=8>
<x=1, y=7, z=-10>
<x=16, y=-5, z=3>
