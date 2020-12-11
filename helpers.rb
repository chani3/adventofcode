
class Helpers
  def self.linesToInts(lines)
    return lines.map(&:to_i)
  end
  def self.strToInts(s)
    return linesToInts(s.split(','))
  end
  def self.loadData
    data = nil
    if ARGV.length > 0
      filename = ARGV[0]
      File.open(filename, "r") { |file|
        data = file.readlines(chomp:true)
      }
    else
      data = DATA.readlines(chomp:true)
    end
    return data
  end
end

