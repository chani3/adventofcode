#!/usr/bin/ruby

sData=DATA.readlines[0].split(',').map(&:to_i)

class IntCode
    def getInput
        p "pulling from #{@inQ}"
        return @inQ.pop
    end
    def output(o)
        @outQ << o
    end
    def sum(a, b)
        a + b
    end
    def mult(a, b)
        a*b
    end
    opSum = { params: 3, ret: :value, run: :sum }
    opMult = { params: 3, ret: :value, run: :mult }
    opInput = { params: 1, ret: :value, run: :getInput }
    opOutput = { params: 1, run: :output }
    opEnd = { params: 0, ret: :exit } #fffff return broke
    opJumpT = { params: 2, ret: :jump, run: :jumpT }
    def jumpT(test, p)
        if test != 0
            p
        else
            -1
        end
    end
    opJumpF = { params: 2, ret: :jump, run: :jumpF }
    def jumpF(test, p)
        if test == 0
            p
        else
            -1
        end
    end
    opLess = { params: 3, ret: :value, run: :less }
    def less(a, b)
        a < b ? 1 : 0
    end
    opEqual = { params: 3, ret: :value, run: :equal }
    def equal(a, b)
        a == b ? 1 : 0
    end

    OpCodes = { 1 => opSum, 2 => opMult, 3 => opInput, 4 => opOutput,
            5 => opJumpT, 6 => opJumpF, 7 => opLess, 8 => opEqual,
            9 => opEnd }

    def initialize(data, inputQueue, outputQueue)
        @data = data.dup
        @inQ = inputQueue
        @outQ = outputQueue
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
            if op[:ret] == :exit
                return
            end

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
            #have to get the exact right # of args now
            if (op[:ret] == :value)
                params.pop
            end
            #p params
            ret = self.send(op[:run], *params)
            #p "returned #{ret}"
            if (op[:ret] == :value)
                @data[paramAddrs.last] = ret
            elsif op[:ret] == :jump && ret >= 0
                ip = ret
            end
        end
    end
end

def trySequence(seq, data)
    p "trying #{seq}"
    queues = Array.new(5) {Queue.new}
    amps = []

    seq.each_with_index { |setting, i|
        queues[i] << setting
        amps << IntCode.new(data, queues[i], queues[(i+1)%5])
    }
    queues[0] << 0
    #run in threads
    threads = []
    amps.each { |amp|
        threads << Thread.new {
            amp.run
        }
    }
    threads.last.join

    return queues[0].pop
end

p "hello"
maxSignal = 0

(5..9).to_a.permutation { |p|
    signal = trySequence(p, sData)
    if signal > maxSignal
        maxSignal = signal
    end
}

p maxSignal

__END__
3,8,1001,8,10,8,105,1,0,0,21,34,51,76,101,114,195,276,357,438,99999,3,9,1001,9,3,9,1002,9,3,9,4,9,99,3,9,101,4,9,9,102,4,9,9,1001,9,5,9,4,9,99,3,9,1002,9,4,9,101,3,9,9,102,5,9,9,1001,9,2,9,1002,9,2,9,4,9,99,3,9,1001,9,3,9,102,2,9,9,101,4,9,9,102,3,9,9,101,2,9,9,4,9,99,3,9,102,2,9,9,101,4,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,99
