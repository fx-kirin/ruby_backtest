require_relative "../price_feeds/price_feeds"
class Backtest
  
  def initialize(trader)
    @feeds = PriceFeeds.new
    @trader = trader.new(@feeds)
  end
  
  # Start Backtesting
  def run(symbol, start_date, end_date)
    @trader.setup
    @feeds.set_base_symbol(symbol, start_date)
    while(@feeds.time(symbol, 0) >= end_date)
      @trader.run
      begin
        @feeds.go_forward
      rescue PriceFeeds::OutOfRangeException
      end
    end
    close_all_positions
    @trader.finalize
  end
  
  private
  def close_all_positions
    
  end
end