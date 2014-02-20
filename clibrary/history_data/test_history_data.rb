require "pry"
require "benchmark"
require_relative "history_data"

h = HistoryData.new
path = "C:\\Users\\Zenbook\\SkyDrive\\AptanaStudio\\workspace\\ruby_trade\\data\\hst\\USDJPY60.hst"
h.load(path)

#binding.pry
pos = 0
# symbol
h.get(0, 0, pos, 256)
pos += 256

# digits
h.get(1, 0, pos, 4)
pos += 4

# data size
size = h.get(1, 0, pos, 8)
pos += 8

total = 0
puts Benchmark::CAPTION
puts Benchmark.measure {
  size.times{
    # Time
    h.get(3, 0, pos, 8)
    pos += 8
    
    # Open, Close, High, Low
    h.get(2, 0, pos, 8)
    pos += 8
    h.get(2, 0, pos, 8)
    pos += 8
    h.get(2, 0, pos, 8)
    pos += 8
    h.get(2, 0, pos, 8)
    pos += 8
    
    # Volume
    total += h.get(1, 0, pos, 4)
    pos += 4
  }
}
puts total