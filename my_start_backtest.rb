require "benchmark"
require_relative "lib/backtest/backtest"

trader = CandleReverseRatio
require "csv"
symbolss = CSV.read(File.expand_path("../data/list/whole_stock_list.csv", __FILE__)).map{|symbols|symbols.map{|symbol|("JP"+symbol).to_sym}}

puts Benchmark::CAPTION
puts Benchmark.measure {
  symbolss.each{|symbols|
    symbols.each{|symbol|
      begin
        puts symbol
        spread = {symbol => 0.000}
        @backtest = Backtest.new(trader)
        start_date = Time.parse("2007.01.10 00:00")
        end_date = Time.parse("2014.01.30 00:00")
        @backtest.run(symbol, start_date, end_date, spread)
      rescue
        puts $!
        puts "failed"
      end
    }
  }
}
