require "csv"
require_relative "price_pair"

class PriceFeeds
  # - date : Start time.
  def initialize(date = 0)
    @date = date
    @pair = Hash.new
  end
  
  # Set price data to the class.
  # - symbol : The symbol of data to be managed.
  # - csv : Data list.
  # - period : data time scale by seconds. If it is 5-minute-division data, set 300.
  #            If you want to use tick data, set 0.
  def set_data(symbol, csv, period)
    @pair[symbol] = read_csv_data(csv)
  end
  
  # Go forward to next bar.
  def go_forward
    
  end
  
  # Get close price of indicated bar.
  # symbol : The symbol of data.
  # bar : The number of bar. If you want to use current bar, it's 0.
  def close(symbol, bar)
    
  end
  
  def high(symbol, bar)
    
  end
  
  def low(symbol, bar)
    
  end
  
  def open(symbol, bar)
    
  end
  
  def time(symbol, bar)
    
  end
  
  def volume(symbol, bar)
    
  end
  
  private
  def read_csv_data(csv)
    pair = PricePair.new
    
  end
end