#!/usr/bin/ruby

#single-line input this time
$data=DATA.readlines[0].split(',').map(&:to_i)

def runCode(noun, verb)
    myData = $data.clone
    myData[1] = noun
    myData[2] = verb
    myData.each_slice(4){ |opArray|
        op = opArray[0]
        p1 = opArray[1]
        p2 = opArray[2]
        dest = opArray[3]
        if op == 99
            return myData[0]
        elsif op == 1
            myData[dest] = myData[p1] + myData[p2]
        elsif op == 2
            myData[dest] = myData[p1] * myData[p2]
        else
            #p "invalid opcode #{op}"
            return -1
        end
    }
end

(0..99).each { |noun|
    (0..99).each { |verb|
        p "data0 is #{$data[0]}"
        output = runCode(noun, verb)
        p "noun: #{noun} verb: #{verb} output: #{output}"

        if output == 19690720
            p 100 * noun + verb
            return
        end
    }
}

__END__
1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,9,19,1,5,19,23,1,6,23,27,1,27,10,31,1,31,5,35,2,10,35,39,1,9,39,43,1,43,5,47,1,47,6,51,2,51,6,55,1,13,55,59,2,6,59,63,1,63,5,67,2,10,67,71,1,9,71,75,1,75,13,79,1,10,79,83,2,83,13,87,1,87,6,91,1,5,91,95,2,95,9,99,1,5,99,103,1,103,6,107,2,107,13,111,1,111,10,115,2,10,115,119,1,9,119,123,1,123,9,127,1,13,127,131,2,10,131,135,1,135,5,139,1,2,139,143,1,143,5,0,99,2,0,14,0
