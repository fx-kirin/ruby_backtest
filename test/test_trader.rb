require_relative "test_master"
require_relative "../lib/trader/trader"
require_relative "../lib/backtest_order_manager/backtest_order_manager"

class TestTrader < TestMaster
  def setup
    @feeds = PriceFeeds.new
    @manager = BacktestOrderManager.new
    @trader = TraderMock.new(@feeds, @manager)
  end
  
  def test_setup
    base_date = Time.parse("2007.01.02 07:00")
    assert_nothing_raised("Setup load error."){
      @trader.setup
      @trader.set_base_symbol(:USDJPY60, base_date)
    }
  end
  
  def test_run
    base_date = Time.parse("2007.01.10 07:00")
    @trader.setup
    @trader.set_base_symbol(:USDJPY60, base_date)
    @trader.set_spread(:USDJPY60, 0.003)
    100.times{
      @trader.run
      @feeds.go_forward
    }
  end
end