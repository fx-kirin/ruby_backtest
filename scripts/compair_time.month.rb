require "benchmark"
require "time"
require "pry"
require_relative "../clibrary/history_data/history_data"

Benchmark.bm(15) do |x|
  x.report("Time.month : ") { 2500000.times{Time.now.month} }
  x.report("tm_mon : ") { 2500000.times{rb_time_to_type(1, Time.now.to_i)}}
  x.report("Time.to_i  : ") { 2500000.times{rb_time_to_type(1, Time.now.to_i)}}
end

Benchmark.bm(20) do |x|
  x.report("Time.parse : ") { 2500000.times{Time.parse("2007.01.02 07:00")} }
  x.report("read from memory: ") { 
    h = HistoryData.new
    path = "C:\\Users\\Zenbook\\SkyDrive\\AptanaStudio\\workspace\\ruby_trade\\data\\hst\\USDJPY60.hst"
    h.load(path)
    2500000.times{
      h.get(3, 0, 268, 8)
    }
  }
end