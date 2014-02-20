# Test PriceFeeds
require "time"
require_relative "test_master"
require "price_feeds/clibrary/price_feeds"

# PriceFeeds class has these methods, symbol, close, open, high and low to get market data.
# symbol is used to choose data.
class TestClibraryPriceFeeds < TestMaster
  def setup
    @feeds = PriceFeeds.new
  end
  
  def test_get_chart_data
    @feeds.set_data(:USDJPY60)
    @feeds.set_data(:EURJPY60)
    assert_equal(@feeds.send(:get_chart_data, :USDJPY60, :close, 0), 119.01, "get_char_data failed")
    assert_raise(RuntimeError, "get_chart_data bar does not exist but does not raise an error."){
      @feeds.send(:get_chart_data, :nothing, :close, 0)
    }
    assert_raise(RuntimeError, "get_chart_data bar is negative but does not raise an error."){
      @feeds.send(:get_chart_data, :USDJPY60, :close, -1)
    }
    assert_equal(@feeds.send(:get_chart_data, :EURJPY60, :close, 0), 157.12, "Something wrong when add 2 pairs.")
  end
  
  # set_data
  def test_set_data
    @feeds.set_data(:USDJPY60)
    assert_equal(@feeds.close(:USDJPY60, 0), 119.01, "close value is wrong.")
  end
  
  def test_set_bar_from_date
    @feeds.set_data(:USDJPY60)
    date = Time.parse("2007.01.02 08:40")
    assert_equal(@feeds.send(:set_bar_from_date, :USDJPY60, date), 100, "Couldn't pick up the right bar.")
    assert_equal(@feeds.time(:USDJPY60, 0), date, "Time is wrong.")
  end
  
  def test_go_forward
    base_date = Time.parse("2007.01.02 07:00")
    date = Time.parse("2007.01.02 07:03")
    
    @feeds.set_data(:USDJPY60)
    @feeds.set_data(:EURJPY60)
    assert_raise(RuntimeError, "Must raise an error when call go_foward before set base_symbol"){
      @feeds.go_forward
    }
    @feeds.set_base_symbol(:USDJPY60, base_date)
    3.times{
      @feeds.go_forward
    }
    assert_equal(@feeds.instance_eval{@bar[:USDJPY60]}, 3, "Bar of base symbol is wrong. go_forward didn't work well.")
    assert_equal(@feeds.instance_eval{@bar[:EURJPY60]}, 3, "Bar of other symbol is wrong. go_forward didn't work well.")
    assert_raise(PriceFeeds::OutOfRangeException, "Nothing raised even read data more than scv file has."){
      2600000.times{
        @feeds.go_forward
      }
    }
  end
end