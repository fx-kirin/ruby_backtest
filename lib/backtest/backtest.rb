require_relative "../trader/trader"
require_relative "../backtest_order_manager/backtest_order_manager"
require_relative "../price_feeds/clibrary/price_feeds"
class Backtest
  def initialize(trader, set_params = [])
    @feeds = PriceFeeds.new
    @manager = BacktestOrderManager.new
    @trader = trader.new(@feeds, @manager)
    @set_params = set_params
  end
  
  # Start Backtesting
  def run(symbol, start_date, end_date, spread_list = {})
    @trader.setup
    @set_params.each{|key, value|
      @trader.set_param(key.to_s, value)
    }
    @trader.set_base_symbol(symbol, start_date)
    spread_list.each{|sym, spread|
      @trader.set_spread(sym, spread)
    }
    month = 0
    while(@feeds.time(symbol, 0) < end_date)
      #now_month = @feeds.time(symbol, 0).month
      #print("backtest is working " + @feeds.time(symbol, 0).to_s + "\r") unless month == now_month
      #month = now_month
      @trader.run
      begin
        @feeds.go_forward
      rescue PriceFeeds::OutOfRangeException
        break
      end
    end
    close_all_positions
    @trader.finalize
    @trader.output
  end
  
  private
  def close_all_positions
    @trader.get_open_positions.each{|pos|
      @trader.close_order(pos)
    }
  end
end