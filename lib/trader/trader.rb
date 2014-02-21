require_relative "../price_feeds/clibrary/price_feeds"

class Trader
  # Trader class will be called from Backtest
  #
  # "setup" method is for initial setup for Backtest.
  # "run" method will be called each bars.
  # "finalize" method will be call when backtest finished.
  #
  # In your own trader, you've got to inherit Trader class.
  # And set "setup", "run". "finalize" methods. 
  #
  # csv data must be stocked in data folder.
  # csv file name must be the same as trade symbol.
  OrderLong = 1
  OrderShort = 2
  
  
  # - feeds : A instance of PriceFeeds class
  # - manager : A instance of BacktestOrderManager
  def initialize(feeds, manager)
    @feeds = feeds
    @manager = manager
    @base_symbol = nil
    @spread = {}
  end
  
  def set_spread(symbol, spread)
    @spread[symbol] = spread
  end
  
  # Initial setup to start backtest.
  # You must load historical data in this method.
  # - feed : A instance of PriceFeeds class
  def setup
    
  end
  
  # The action when you get a new bar.
  def run
    
  end
  
  # When finalize backtest.
  def finalize
    
  end
  
  def set_base_symbol(symbol, base_date)
    load(symbol)
    @base_symbol = symbol
    @feeds.set_base_symbol(symbol, base_date)
  end
  
  def get_open_positions(magic_number=0)
    @manager.get_open_positions(magic_number)
  end
  
  def open_order(symbol, order_type, lots, take_profit, stop_loss, magic_number)
    case order_type
    when OrderLong
      open_price = ask
    when OrderShort
      open_price = bid
    end
    open_time = @feeds.time(symbol, 0)
    @manager.open_order(symbol, order_type, open_price, lots, take_profit, stop_loss, magic_number, open_time)
  end
  
  def close_order(order)
    case order.order_type
    when OrderShort
      close_price = ask
    when OrderLong
      close_price = bid
    end
    close_time = @feeds.time(order.symbol, 0)
    @manager.close_order(order.order_number, close_price, close_time)
  end
  
  def order_exists?(magic_number=0)
    @manager.get_open_positions(magic_number).length > 0 ? true : false
  end
  
  def get_order(magic_number)
    pos = @manager.get_open_positions(magic_number)
    raise "Position does not exist." if pos.length == 0
    pos[0]
  end
  
  private
  def load(symbol)
    @feeds.set_data(symbol)
  end
  
  def open(bar)
    @feeds.open(@feeds.get_base_symbol, bar)
  end
  
  def close(bar)
    @feeds.close(@feeds.get_base_symbol, bar)
  end
  
  def high(bar)
    @feeds.high(@feeds.get_base_symbol, bar)
  end
  
  def low(bar)
    @feeds.low(@feeds.get_base_symbol, bar)
  end
  
  def time(bar)
    @feeds.time(@feeds.get_base_symbol, bar)
  end
  
  def i_open(symbol, bar)
    @feeds.open(symbol, bar)
  end
  
  def i_close(symbol, bar)
    @feeds.close(symbol, bar)
  end
  
  def i_high(symbol, bar)
    @feeds.high(symbol, bar)
  end
  
  def i_low(symbol, bar)
    @feeds.low(symbol, bar)
  end
  
  def i_time(symbol, bar)
    @feeds.time(symbol, bar)
  end
  
  def moving_average(symbol, type, period, bar)
    @feeds.moving_average(symbol, type, period, bar)
  end
  
  def bid
    close(0)
  end
  
  def ask
    @spread.has_key?(base_symbol) ? close(0) + @spread[base_symbol] : close(0)
  end
  
  def base_symbol
    @base_symbol
  end
end

# Load every trader
traders_path = File.expand_path("../../../traders", __FILE__)
Dir::foreach(traders_path) do |v|
  next if v == "." or v == ".."
  require_relative "%s/%s"%[traders_path, v]
end