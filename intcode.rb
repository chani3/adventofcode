
class IntCode
    def getInput
        #p "pulling from #{@inQ}"
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
    opRelBase = { params: 1, ret: :rb, run: :adjRelBase }
    def adjRelBase(a)
        a
    end

    OpCodes = { 1 => opSum, 2 => opMult, 3 => opInput, 4 => opOutput,
            5 => opJumpT, 6 => opJumpF, 7 => opLess, 8 => opEqual,
            9 => opRelBase, 99 => opEnd }

    def initialize(data, inputQueue, outputQueue)
        @data = data.dup
        @inQ = inputQueue
        @outQ = outputQueue
    end
    def run()
        ip = 0
        relBase = 0
        loop do
            opField = @data[ip].digits
            opCode = opField[0]
            if opField[1]
                opCode += 10*opField[1]
            end
            paramModes = opField.slice(2,3)
            paramModes ||= [] 
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
                if paramModes[i] == 1
                    paramAddrs[i] = ip
                    #p "direct mode #{i}"
                else
                    paramAddrs[i] = @data[ip]
                    #p "normal mode #{i}"
                    if paramModes[i] == 2
                        paramAddrs[i] += relBase
                        #p "rel mode #{i}"
                    end
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
            elsif op[:ret] == :rb
                relBase += ret
                #p "set rb to #{relBase}"
            end
        end
    end
end

