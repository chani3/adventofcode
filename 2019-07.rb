#!/usr/bin/ruby

sData=DATA.readlines[0].split(',').map(&:to_i)
#io is suuuch a hack atm
$output = 0
$input = []
def initInput(values)
    $input = values
end
def getInput
    return $input.shift
end

class IntCode
    opSum = { params: 3, ret: :value, run: Proc.new { |a, b| a + b } }
    opMult = { params: 3, ret: :value, run: Proc.new{ |a, b| a * b } }
    opInput = { params: 1, ret: :value, run: Proc.new{ getInput }}
    opOutput = { params: 1, run: Proc.new{ |o| $output = o[0] }}
    opEnd = { params: 0, ret: :exit, run: Proc.new{}} #fffff return broke
    opJumpT = { params: 2, ret: :jump, run: Proc.new{ |test, p|
    if test != 0
        p
    else
        -1
    end
}}
    opJumpF = { params: 2, ret: :jump, run: Proc.new{ |test, p|
    if test == 0
        p
    else
        -1
    end
}}
    opLess = { params: 3, ret: :value, run: Proc.new{ |a, b| a < b ? 1 : 0}}
    opEqual = { params: 3, ret: :value, run: Proc.new{ |a, b| a == b ? 1 : 0}}

    OpCodes = { 1 => opSum, 2 => opMult, 3 => opInput, 4 => opOutput,
            5 => opJumpT, 6 => opJumpF, 7 => opLess, 8 => opEqual,
            9 => opEnd }

    def initialize(data, input)
        @data = data.dup
        initInput(input)
    end
    def run()
        ip = 0
        loop do
            opField = @data[ip].digits
            opCode = opField[0]
            paramModes = opField.slice(2,3)
            paramAddrs = []
            op = OpCodes[opCode]
            #p "opfield is #{opField}"
            #p "op is #{op}"
            #p "pM is #{paramModes}"
            #get params
            op[:params].times { |i|
                ip+=1
                if paramModes && paramModes[i] == 1
                    paramAddrs[i] = ip
                    #p "direct mode #{i}"
                else
                    paramAddrs[i] = @data[ip]
                    #p "normal mode #{i}"
                end
            }
            ip += 1
            #p paramAddrs
            params = paramAddrs.map { |addr| @data[addr] }
            #p params
            ret = op[:run].call(params)
            #p "returned #{ret}"
            if (op[:ret] == :value)
                @data[paramAddrs.last] = ret
            elsif op[:ret] == :jump && ret >= 0
                ip = ret
            elsif op[:ret] == :exit
                return
            end
        end
    end
end

def trySequence(seq, data)
    p "trying #{seq}"
    acc = 0
    seq.each { |setting|
        IntCode.new(data, [setting, acc]).run()
        acc = $output
    }
    return acc
end

p "hello"
maxSignal = 0

(0..4).to_a.permutation { |p|
    signal = trySequence(p, sData)
    if signal > maxSignal
        maxSignal = signal
    end
}

p maxSignal

__END__
3,8,1001,8,10,8,105,1,0,0,21,34,51,76,101,114,195,276,357,438,99999,3,9,1001,9,3,9,1002,9,3,9,4,9,99,3,9,101,4,9,9,102,4,9,9,1001,9,5,9,4,9,99,3,9,1002,9,4,9,101,3,9,9,102,5,9,9,1001,9,2,9,1002,9,2,9,4,9,99,3,9,1001,9,3,9,102,2,9,9,101,4,9,9,102,3,9,9,101,2,9,9,4,9,99,3,9,102,2,9,9,101,4,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,99
