# Test PriceFeeds
require_relative "test_master"
require_relative "../lib/backtest/backtest"

class TestBacktest < TestMaster
  def setup
    @backtest = Backtest.new(TraderMock)
  end

  def test_run
    start_date = Time.parse("2007.01.10 07:00")
    end_date = Time.parse("2013.01.30 07:00")
    @backtest.run(:USDJPY60, start_date, end_date, {:USDJPY60 => 0.003})
  end
  
  def test_set_param
    require "csv"
    path = File.expand_path("../../result/opt_TraderMock.csv", __FILE__)
    File.delete(path) if File.exists?(path)

    @backtest = Backtest.new(TraderMock, {:param1 => 10, :param2 => 20})
    start_date = Time.parse("2007.01.10 07:00")
    end_date = Time.parse("2013.01.30 07:00")
    @backtest.run(:USDJPY60, start_date, end_date, {:USDJPY60 => 0.003})
    result = CSV.read(path)
    assert_equal(result[0][7], "param1")
    assert_equal(result[0][8], "param2")
    assert_equal(result[1][7], "10")
    assert_equal(result[1][8], "20")
  end
end