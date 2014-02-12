require_relative "../price_feeds/price_feeds"
class Backtest
  
  def initialize(trader)
    @feed = PriceFeeds.new
    @trader = trader.new(@feed)
  end
  
  # Start Backtesting
  def run(symbol, start_date, end_date)
    @trader.setting
    @feed.set_base_symbol(symbol, start_date)
    while(@feed.time(symbol, 0) >= end_date)
      @trader.start
      begin
        @feed.go_forward
      rescue PriceFeeds::OutOfRangeException
      end
    end
    close_all_positions
    @trader.finishing
  end
  
  def close_all_positions
    
  end
end