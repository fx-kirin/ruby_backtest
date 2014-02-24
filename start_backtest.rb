require "benchmark"
require_relative "lib/backtest/backtest"

@backtest = Backtest.new(StockTrader)
start_date = Time.parse("2007.01.10 00:00")
end_date = Time.parse("2014.01.30 00:00")
puts Benchmark::CAPTION
puts Benchmark.measure {
  @backtest.run(:nihon9984, start_date, end_date, {:nihon9984 => 0.000})
}