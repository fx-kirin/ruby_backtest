require 'benchmark'
require_relative "test_master"
require_relative "../lib/backtest_order_manager/backtest_order_manager"

class TestBacktestOrderManager < TestMaster
  def setup
    @manager = BacktestOrderManager.new
  end
  
  def test_open_order
    @manager.open_order(:USDJPY, 1, 100.00, 10, 101, 99, 1234, Time.now)
    pos = @manager.get_positions(1235)
    assert_equal(pos.length, 0, "Magic number is wrong but data was found.")
    pos = @manager.get_positions(1234)
    assert_equal(pos.length, 1, "Order is not opened.")
    order_number = pos[0].order_number
    @manager.close_order(order_number, 100.50, Time.now + 60)
    pos = @manager.get_positions(1234)
    assert_equal(pos.length, 0, "Order is not closed.")
  end
  
  def test_open_order_time
    puts Benchmark::CAPTION
    puts Benchmark.measure{
      500.times{
        @manager.open_order(:USDJPY, 1, 100.00, 10, 101, 99, 1234, Time.now)
      }
    }
  end
end