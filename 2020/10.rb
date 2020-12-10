#!/usr/bin/ruby
require_relative "../helpers"
data = Helpers.linesToInts(Helpers.loadData).sort

last = 0
joltSums = [0,0,0,1]
joltList = []
data.each { |num|
  jolt = num - last
  joltSums[jolt] += 1
  joltList << jolt
  last = num
}
joltList << 3
p joltSums[1]*joltSums[3]
p data.size
p joltList.size

maybeSkip = {}
definiteSkipCount = 0
skipOrRunCount = 0
skipPrev = false
runs = []
runStart = -1
(0..data.size-1).each { |i|
  #can't fucking think straight
  #so I'm trying to narrow down the options.
  #3-jumps are unskippable, 2+2 isn't skippable
  #1+1 or 1+2 are at least semi-skippable
  joltA = joltList[i]
  joltB = joltList[i+1]
  sum = joltA + joltB
  skip = sum <= 3
  if skip
    maybeSkip[i] = true
    if runStart == -1
      runStart = i
    end
  elsif skipPrev
    #just finished a region, how big is it?
    if i-runStart > 1
      runs << [runStart, i-1]
    else
      definiteSkipCount += 1
    end
    runStart = -1
    skipOrRunCount += 1
  end
  skipPrev = skip
}
ways = 2**definiteSkipCount
p maybeSkip.size
p skipOrRunCount
p definiteSkipCount
p ways
p runs
#now, 2^size is an upper bound, but runs of small jumps will produce less than that because you need some in the middle to bridge the gaps.
#so how do those gaps affect the numbers? especially when the bridge number can be different things
#can I brute-force from here, test every option?
#how do I even do that?
#I don't want permutations, I want... all possible subsets of the set. like 1..2^n where each bit is one of the entries to skip/use.
#so... select, 2^n times? but how do I track which things to select?
#
#alternatively, can I break it up into regions and tackle them?
#42 regions for 50 skippables, yeah I think I can... 

#runs are either 2 or 3, so what are the options there?
#all 1s, which for 2 means all valid, for 3 means one invalid (can't skip all at once)
#a run of 2 that sums to 4 or 5 has 3 instead of 4 valid
#a run of 3 that sums to 6 has 5 instead of 7
#a run of 3 that sums to 5 has 5 or 6 depending on where the 2 is.
#so, 2s: 3 or 4 based on just the sum.
#3s: 5, 6 or 7 based on where the 2s are.
runs.each { |run|
  first = run[0]
  last = run[1]
  sum = (first..last+1).sum { |i|
    #p "i #{i} jolt #{joltList[i]}"
    joltList[i]
  }
  length = last - first + 1
  mult = -1
  if length == 2
    mult = (sum > 3 ? 3 : 4)
  elsif sum == 4
    mult = 7
  elsif sum == 6
    mult = 5
  else
    #2 in the middle -> 5, 2 at an end -> 6
    if joltList[first] == 2 or joltList[last] == 2
      mult = 6
    else
      mult = 5
    end
  end
  p "lenght #{length} sum #{sum} mult #{mult}"
  ways = mult * ways
}
p ways

__END__
74
153
60
163
112
151
22
67
43
160
193
6
2
16
122
126
32
181
180
139
20
111
66
81
12
56
63
95
90
161
33
134
31
119
53
148
104
91
140
36
144
23
130
178
146
38
133
192
131
3
73
11
62
50
89
98
103
110
164
48
80
179
92
194
86
40
13
123
68
115
19
46
77
152
138
69
49
59
30
132
9
185
1
188
171
72
116
101
61
141
107
21
47
147
182
170
39
37
127
26
102
137
191
162
172
29
10
154
157
83
82
175
145
167
