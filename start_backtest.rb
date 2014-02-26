require "benchmark"
require_relative "lib/backtest/backtest"

trader = CandleReverseRatio
symbol = :JP8303
spread = {symbol => 0.000}

@backtest = Backtest.new(trader)
start_date = Time.parse("2007.08.10 00:00")
end_date = Time.parse("2014.01.30 00:00")
puts Benchmark::CAPTION
puts Benchmark.measure {
  @backtest.run(symbol, start_date, end_date, spread)
}