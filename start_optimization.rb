require "benchmark"
require_relative "lib/optimization/optimization"

trader = StockTrader
symbol = :nihon9984

start_date = Time.parse("2007.01.10 00:00")
end_date = Time.parse("2014.03.30 00:00")
opts = []
opts << OptSetting.new("ma_period", 10, 5, 200)
opts << OptSetting.new("devision", 0.01, 0.01, 0.5)
opt = Optimization.new(trader, opts, symbol, start_date, end_date, {symbol => 0.000})
opt.run
