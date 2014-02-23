require "time"

require_relative "test_master"
require_relative "../lib/price_feeds/clibrary/history_center"

class TestHistoryCenter < TestMaster
  def setup
    @center = HistoryCenter.new
  end
  
  def test_load
    symbol = :USDJPY60test
    assert_raises(HistoryCenter::HistoryFileNotExist, "Must Raise HistoryFileNotExist"){
      @center.load(:Nothing)      
    }
    assert_nothing_raised("load failed"){
      @center.load(symbol)
    }
    assert_equal(@center.instance_eval("@max_bars[:%s]"%[symbol.to_s]), 2553658, "max_bars failed.")
    assert_equal(@center.instance_eval("@digits[:%s]"%[symbol.to_s]), 5, "digits failed.")
  end
  
  def test_get_data
    symbol = :USDJPY60test
    @center.load(symbol)
    assert_equal(@center.get_data(symbol, 0, :time), Time.parse("2007-01-02 07:00:00 +0900"), "Bar0 PriceTime Failed.")
    assert_equal(@center.get_data(symbol, 0, :open), 119.01, "Bar0 PriceOpen Failed")
    assert_equal(@center.get_data(symbol, 0, :close), 119.01, "Bar0 PriceClose Failed")
    assert_equal(@center.get_data(symbol, 0, :low), 119.01, "Bar0 PriceLow Failed")
    assert_equal(@center.get_data(symbol, 0, :high), 119.01, "Bar0 PriceHigh Failed")
    assert_equal(@center.get_data(symbol, 0, :volume), 8, "Bar0 PriceVolume Failed")
    
    assert_equal(@center.get_data(symbol, 1, :time), Time.parse("2007-01-02 07:01:00 +0900"), "Bar1 PriceTime Failed.")
    assert_equal(@center.get_data(symbol, 1, :open), 119.01, "Bar1 PriceOpen Failed")
    assert_equal(@center.get_data(symbol, 1, :close), 119.01, "Bar1 PriceClose Failed")
    assert_equal(@center.get_data(symbol, 1, :low), 119.01, "Bar1 PriceLow Failed")
    assert_equal(@center.get_data(symbol, 1, :high), 119.01, "Bar1 PriceHigh Failed")
    assert_equal(@center.get_data(symbol, 1, :volume), 8, "Bar1 PriceVolume Failed")
    
    assert_equal(@center.get_data(symbol, 2553657, :time), Time.parse("2013-11-14 06:59:00 +0900"), "Bar2553657 PriceTime Failed.")
    assert_equal(@center.get_data(symbol, 2553657, :open), 99.211, "Bar2553657 PriceOpen Failed")
    assert_equal(@center.get_data(symbol, 2553657, :close), 99.237, "Bar2553657 PriceClose Failed")
    assert_equal(@center.get_data(symbol, 2553657, :low), 99.21, "Bar2553657 PriceLow Failed")
    assert_equal(@center.get_data(symbol, 2553657, :high), 99.237, "Bar2553657 PriceHigh Failed")
    assert_equal(@center.get_data(symbol, 2553657, :volume), 8, "Bar2553657 PriceVolume Failed")
    
    assert_raises(HistoryCenter::OutOfRangeException, "Must Raise HistoryFileNotExist"){
      @center.get_data(symbol, 2553658, :time)     
    }
  end
  
  def test_moving_average
    symbol = :USDJPY60test
    @center.load(symbol)
    [:open, :close, :high, :low].each{|type|
      assert_equal(@center.moving_average(symbol, type, 100, 1000), rb_moving_average(symbol, type, 100, 1000))
    }
  end
  
  private
  def rb_moving_average(symbol, type, period, bar)
    ave = 0
    period.times{|i|
      ave += @center.get_data(symbol, bar - i, type)
    }
    ave /= period
    ave
  end
end