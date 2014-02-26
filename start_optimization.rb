require "benchmark"
require_relative "lib/optimization/optimization"

trader = StockTrader
symbol = :JP8303
spread = {symbol => 0.000}
opts = []
opts << OptSetting.new("ma_period", 10, 5, 200)
opts << OptSetting.new("devision", 0.01, 0.01, 0.5)

start_date = Time.parse("2007.08.10 00:00")
end_date = Time.parse("2014.01.30 00:00")

opt = Optimization.new(trader, opts, symbol, start_date, end_date, {})
opt.run
