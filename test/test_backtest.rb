# Test PriceFeeds
require_relative "test_master"
require_relative "../lib/backtest/backtest"

class TestBacktest < TestMaster
  def setup
    @backtest = Backtest.new(TraderMock)
  end

  def test_run
    start_date = Time.parse("2007.01.10 07:00")
    end_date = Time.parse("2007.01.30 07:00")
    @backtest.run(:USDJPY60, start_date, end_date, {:USDJPY60 => 0.003})
  end
end