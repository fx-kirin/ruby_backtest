require_relative "test_master"
require_relative "../lib/trader/trader"

class TestTrader < TestMaster
  def setup
    @feeds = PriceFeeds.new
    @trader = TraderMock.new(@feeds)
  end
  
  def test_setup
    assert_nothing_raised("Setup load error."){
      @trader.setup
    }
  end
  
  def test_run
    base_date = Time.parse("2007.01.02 07:00")
    @trader.setup
    @feeds.set_base_symbol(:USDJPY60, base_date)
    100.times{
      @trader.run
      @feeds.go_forward
    }
  end
end