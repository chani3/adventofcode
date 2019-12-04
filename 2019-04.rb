#!/usr/bin/ruby

data = DATA.readlines[0].split("-")
min = data[0].to_i
max = data[1].to_i
p "#{min} to #{max}"

def valid(pass)
    foundDouble = false
    digits = pass.digits
    (0..4).each { |i|
        if digits[i] > digits[i+1]
            return false
        elsif digits[i] == digits[i+1]
            foundDouble = true
        end
    }
    return foundDouble
end

valids = (min..max).select {|pass| valid(pass)}
p valids.length
__END__
265275-781584
