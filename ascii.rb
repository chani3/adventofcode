
class AsciiCode
    def initialize(runner)
        @inQ = runner.inQ
        @outQ = runner.outQ
        @map = [[]]
        @currentLine = 0
    end
    def sendCode(codeString)
        codeString.bytes.each { |byte|
            @inQ << byte
        }
    end
    def drawBoard
        @map.each { |row|
            p row.join('')
        }
    end
    def getMap
        charCode = @outQ.pop
        if charCode == "!exit"
            p "height #{@map.length} width #{@map[0].length}"
            drawBoard()
            #p doIntersections(map)
            return false
        elsif charCode > 999 #lol hax
            p "dust #{charCode}"
            return false
        end
        char = charCode.chr
        if char == "\n"
            #p "newline ##{@currentLine}"
            @currentLine += 1
            @map << []
        else
            #p "got #{char}?"
            @map[@currentLine] << char
        end
        []
    end

end

