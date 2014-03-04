require "benchmark"
require_relative "lib/backtest/backtest"

trader = HighRatioTrader
symbol = :JP7554
spread = {symbol => 0.000}

@backtest = Backtest.new(trader)
start_date = Time.parse("2007.01.01 00:00")
end_date = Time.parse("2014.12.31 00:00")
puts Benchmark::CAPTION
puts Benchmark.measure {
  @backtest.run(symbol, start_date, end_date, spread)
}