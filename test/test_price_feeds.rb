# Test PriceFeeds
require_relative "test_master"
require "price_feeds/price_feeds"

# PriceFeeds class has these methods, symbol, close, open, high and low to get market data.
# symbol is used to choose data.
class TestPriceFeeds < TestMaster
  def setup
    @feeds = PriceFeeds.new
  end
  
  def test_read_csv_data
    assert_nothing_raised("read_csv_data failed."){
      @feeds.send(:read_csv_data, :USDJPY60, File::dirname(__FILE__) + "/sample_data/USDJPY60.csv")
    }
  end
  
  def test_get_chart_data
    @feeds.set_data(:USDJPY, File::dirname(__FILE__) + "/sample_data/USDJPY60.csv")
    @feeds.set_data(:EURJPY, File::dirname(__FILE__) + "/sample_data/EURJPY60.csv")
    assert_equal(@feeds.send(:get_chart_data, :USDJPY, :close, 0), 119.01, "get_char_data failed")
    assert_raise(RuntimeError, "get_chart_data bar does not exist but does not raise an error."){
      @feeds.send(:get_chart_data, :USDJPY, :close, 1)
    }
    assert_raise(RuntimeError, "get_chart_data bar is negative but does not raise an error."){
      @feeds.send(:get_chart_data, :USDJPY, :close, -1)
    }
    assert_equal(@feeds.send(:get_chart_data, :EURJPY, :close, 0), 157.12, "Something wrong when add 2 pairs.")
  end
  
  # set_data
  def test_set_data
    @feeds.set_data(:USDJPY60, File::dirname(__FILE__) + "/sample_data/USDJPY60.csv")
    assert_equal(@feeds.close(:USDJPY60, 0), 119.01, "close value is wrong.")
  end
  
  def test_set_bar_from_date
    @feeds.set_data(:USDJPY60, File::dirname(__FILE__) + "/sample_data/USDJPY60.csv")
    date = Time.parse("2007.01.02 08:40")
    assert_equal(@feeds.send(:set_bar_from_date, :USDJPY60, date), 101, "Couldn't pick up the right bar.")
    assert_equal(@feeds.time(:USDJPY60, 0), date, "Time is wrong.")
  end
  
  def test_go_forward
    base_date = Time.parse("2007.01.02 07:00")
    date = Time.parse("2007.01.02 07:03")
    
    @feeds.set_data(:USDJPY, File::dirname(__FILE__) + "/sample_data/USDJPY60.csv")
    @feeds.set_data(:EURJPY, File::dirname(__FILE__) + "/sample_data/EURJPY60.csv")
    assert_raise(RuntimeError, "Must raise an error when call go_foward before set base_symbol"){
      @feeds.go_forward
    }
    @feeds.set_base_symbol(:USDJPY, base_date)
    3.times{
      @feeds.go_forward
    }
    assert_equal(@feeds.instance_eval{@bar[:USDJPY]}, 4, "Bar of base symbol is wrong. go_forward didn't work well.")
    assert_equal(@feeds.instance_eval{@bar[:EURJPY]}, 3, "Bar of other symbol is wrong. go_forward didn't work well.")
    assert_raise(PriceFeeds::OutOfRangeException, "Nothing raised even read data more than scv file has."){
      100000.times{
        @feeds.go_forward
      }
    }
  end
end