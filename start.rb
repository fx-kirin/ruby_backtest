require "benchmark"
require_relative "lib/backtest/backtest"

@backtest = Backtest.new(MyTrader)
start_date = Time.parse("2007.01.10 07:00")
end_date = Time.parse("2013.01.30 07:00")
puts Benchmark::CAPTION
puts Benchmark.measure {
  @backtest.run(:USDJPY60, start_date, end_date, {:USDJPY60 => 0.003})
}