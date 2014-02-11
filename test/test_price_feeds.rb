# Test PriceFeeds

# PriceFeeds class has these methods, symbol, close, open, high and low to get market data.
# symbol is used to choose data.
class TestPriceFeeds < Test::Unit::TestCase
  
  def test_read_csv_data
    feeds = PriceFeeds.new
    feeds.send(:read_csv_data, "/sample_data/USDJPY60.csv")
  end
  
  # set_data
  def test_set_data
    feeds = PriceFeeds.new
    feeds.set_data(:USDJPY, File::dirname(__FILE__) + "/sample_data/USDJPY60.csv", 60)
    feeds.close(:USDJPY, 0)
  end
  
  def test_close
    
  end
  
  
end