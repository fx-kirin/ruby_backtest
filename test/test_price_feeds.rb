# Test PriceFeeds
require 'test/unit'

# PriceFeeds class has these methods, symbol, close, open, high and low to get market data.
# symbol is used to choose data.
class TestPriceFeeds < Test::Unit::TestCase
  
  # set_data
  def test_set_data
    feeds = PriceFeeds.new
    feeds.set_data(:USDJPY, "USDJPY60.csv", 60)
    feeds.close(:USDJPY, 0)
  end
  
  def test_close
    
  end
end