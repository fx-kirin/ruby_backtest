require "benchmark"
require_relative "lib/optimization/optimization"

trader = HighRatioTrader
symbol = :JP7554
spread = {symbol => 0.000}
opts = []
opts << OptSetting.new("max_pos", 1, 1, 100)

start_date = Time.parse("2007.01.01 00:00")
end_date = Time.parse("2014.01.30 00:00")

opt = Optimization.new(trader, opts, symbol, start_date, end_date, {})
opt.run
