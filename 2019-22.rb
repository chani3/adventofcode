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

#$deckSize = 10.freeze
$deckSize = 10007.freeze

deck = Array.new($deckSize) { |i| i }

def dealStack(deck)
    p "dealing"
    deck.reverse
end

def cutN(n, deck)
    p "cutting #{n}"
    deck[n..-1] + deck[0..n-1]
end

def incN(n, deck)
    p "inc #{n}"
    newDeck = Array.new($deckSize)
    deck.each_index { |i|
        newDeck[(i*n) % $deckSize] = deck[i]
    }
    return newDeck
end

data.each { |line|
    case line
    when "deal into new stack\n"
        deck = dealStack(deck)
    when /cut (-?\d+)/
        deck = cutN($1.to_i, deck)
    when /deal with increment (\d+)/
        deck = incN($1.to_i, deck)
    else
        p "not implemented!!!!"
    end
}

#p deck
p deck.index(2019)

__END__
deal into new stack
deal with increment 25
cut -5919
deal with increment 56
deal into new stack
deal with increment 20
deal into new stack
deal with increment 53
cut 3262
deal with increment 63
cut 3298
deal into new stack
cut -4753
deal with increment 57
deal into new stack
cut 9882
deal with increment 42
deal into new stack
deal with increment 40
cut 2630
deal with increment 32
cut 1393
deal with increment 74
cut 2724
deal with increment 23
cut -3747
deal into new stack
cut 864
deal with increment 61
deal into new stack
cut -4200
deal with increment 72
cut -7634
deal with increment 32
deal into new stack
cut 6793
deal with increment 38
cut 7167
deal with increment 10
cut -9724
deal into new stack
cut 6047
deal with increment 37
cut 7947
deal with increment 63
deal into new stack
deal with increment 9
cut -9399
deal with increment 26
cut 1154
deal with increment 74
deal into new stack
cut 3670
deal with increment 45
cut 3109
deal with increment 64
cut -7956
deal with increment 39
deal into new stack
deal with increment 61
cut -9763
deal with increment 20
cut 4580
deal with increment 30
deal into new stack
deal with increment 62
deal into new stack
cut -997
deal with increment 54
cut -1085
deal into new stack
cut -9264
deal into new stack
deal with increment 11
cut 6041
deal with increment 9
deal into new stack
cut 5795
deal with increment 26
cut 5980
deal with increment 38
cut 1962
deal with increment 25
cut -565
deal with increment 45
cut 9490
deal with increment 21
cut -3936
deal with increment 64
deal into new stack
cut -7067
deal with increment 75
cut -3975
deal with increment 29
deal into new stack
cut -7770
deal into new stack
deal with increment 12
cut 8647
deal with increment 49
