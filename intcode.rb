
class IntCode
    def self.strToCode(s)
        return line.split(',').map(&:to_i)
    end

    def getInput
        #p "input"
        num = @inQ.pop
        #p "got #{num}"
        return num
    end
    def output(o)
        #p "output #{o}"
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

    def initialize(data, inputQueue, outputQueue, state = [0, 0])
        @data = data.dup
        @inQ = inputQueue
        @outQ = outputQueue
        @ip = state[0]
        @relBase = state[1]
    end
    def saveState
        @outQ << "!save"
        @outQ << [@ip, @relBase, @data]
    end
    def run()
        loop do
            opField = @data[@ip].digits
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
                output "!exit"
                return
            end

            #p "pM is #{paramModes}"
            #get params
            op[:params].times { |i|
                @ip+=1
                if paramModes[i] == 1
                    paramAddrs[i] = @ip
                    #p "direct mode #{i}"
                else
                    paramAddrs[i] = @data[@ip]
                    #p "normal mode #{i}"
                    if paramModes[i] == 2
                        paramAddrs[i] += @relBase
                        #p "rel mode #{i}"
                    end
                end
            }
            @ip += 1
            #p "addrs #{paramAddrs}"
            params = paramAddrs.map { |addr| @data[addr] || 0 }
            #have to get the exact right # of args now
            if (op[:ret] == :value)
                params.pop
            end
            #p "params #{params}"
            ret = self.send(op[:run], *params)
            #p "returned #{ret}"
            if (op[:ret] == :value)
                if (ret == "!save")
                    #rewind that instruction and save our state
                    @ip -= 2
                    saveState
                    #but keep going, no need to quit
                else
                    @data[paramAddrs.last] = ret
                end
            elsif op[:ret] == :jump && ret >= 0
                @ip = ret
            elsif op[:ret] == :rb
                @relBase += ret
                #p "set rb to #{@relBase}"
            end
        end
    end
end

class IntCodeInteractive
    def strToCode(s)
        return s.split(',').map(&:to_i)
    end
    def drawBoard(tiles)
        tiles.each { |row|
            line = ""
            row.each { |tile|
                line += @tileDisplay[tile]
            }
            p line
        }
    end

    def initialize(dataString, state, tileDisplay)
        @inQ = Queue.new
        @outQ = Queue.new
        @tileDisplay = tileDisplay

        data = strToCode(dataString)
        #TODO clean this up
        if (state)
            @code = IntCode.new(data, @inQ, @outQ, state)
        else
            @code = IntCode.new(data, @inQ, @outQ)
        end

    end
    def run
        codeThread = Thread.new {
            @code.run()
        }

        ioThread = Thread.new {
            loop do
                tiles = yield(@inQ, @outQ)
                break if !tiles
                drawBoard(tiles)
                #break if !(codeThread.alive?) && outQ.empty?
            end
        }

        ioThread.join
    end
end

