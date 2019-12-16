#!/usr/bin/ruby

data = nil
if ARGV.length > 0
    filename = ARGV[0]
    File.open(filename, "r") { |file|
        data = file.readlines
    }
else
    data = DATA.readlines
end

list = data[0].chomp.split('').map(&:to_i)
offset = data[0][0..6].to_i

basePattern = [0, 1, 0, -1]

$patterns = {}

def generatePattern(basePattern, pos, length)
    if ! $patterns.has_key? pos
        $patterns[pos] = Array.new(length) { |i|
            basePattern[((i+1)/(pos+1))%4]
        }
    end
    $patterns[pos]
end

def applyPatternToIndex(basePattern, list, i)
    p "#{i}"
    pattern = generatePattern(basePattern, i, list.length)
    #p "pattern for #{i}: #{pattern}"
    value = list.zip(pattern).sum(0) { |e| e[0] * e[1] }
    value.abs % 10
end

def applyPatternToList(basePattern, list)
    p "."
    newList = list.map.with_index { |e, i|
        applyPatternToIndex(basePattern, list, i)
    }
end

#fuuuck this is gonna be slow
list = list * 10000

p offset
100.times { list = applyPatternToList(basePattern, list) }
p list[0, 8]

__END__
59773775883217736423759431065821647306353420453506194937477909478357279250527959717515453593953697526882172199401149893789300695782513381578519607082690498042922082853622468730359031443128253024761190886248093463388723595869794965934425375464188783095560858698959059899665146868388800302242666479679987279787144346712262803568907779621609528347260035619258134850854741360515089631116920328622677237196915348865412336221562817250057035898092525020837239100456855355496177944747496249192354750965666437121797601987523473707071258599440525572142300549600825381432815592726865051526418740875442413571535945830954724825314675166862626566783107780527347044
