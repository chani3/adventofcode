#!/usr/bin/ruby

data = DATA.readlines[0].split("-")
min = data[0].to_i
max = data[1].to_i
p "#{min} to #{max}"

def valid(pass)
    #p "trying #{pass}"
    foundDouble = false
    pendingDouble = false
    doubleOk = true
    digits = pass.digits
    (0..4).each { |i|
        if digits[i] < digits[i+1]
            #p "fail at i=#{i}"
            return false
        elsif digits[i] == digits[i+1]
            #p "double at i=#{i}"
            if pendingDouble
                doubleOk = false
            end
            pendingDouble = true
        elsif pendingDouble
            #resolve the group
            if doubleOk
                foundDouble = true
            end
            pendingDouble = false
            doubleOk = true
        end
    }
    #repeat this in case there's an unresolved double at the end.
    #ugly but whatevr
    if pendingDouble && doubleOk
        foundDouble = true
    end
    #p "double? #{foundDouble}"
    return foundDouble
end

valids = (min..max).select {|pass| valid(pass)}
#p valids
p valids.length
__END__
265275-781584
