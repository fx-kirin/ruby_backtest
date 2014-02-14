require_relative "test_master"
require_relative "../lib/backtest_order_manager/backtest_order_list"

class TestBacktestOrderList < TestMaster
  def setup
    @list = BacktestOrderList.new
  end
  
  def test_insert_get_update_order
    order = @list.new_order
    assert_raise(BacktestOrderList::NoDataFoundException, "Must raise error when order_number is not found."){
      result = @list.get_position(order.order_number)
    }
    
    order.symbol = "USDJPY"
    order.order_type = 1
    order.lots = 10
    order.status = 1
    order.open_price = 100.10
    order.stop_loss = 99.00
    order.take_profit = 101.90
    order.open_time = Time.now.to_s
    result = nil
    
    assert_nothing_raised("insert_order failed."){
      result = @list.insert_order(order)
    }
    assert_raise(BacktestOrderList::OrderNumberIsNotNilException, "Must raise error when insert order with order_number not nil."){
      result = @list.insert_order(order)
    }
    assert_nothing_raised("insert_order failed."){
      result = @list.get_position(order.order_number)
    }
    assert_equal("USDJPY", order.symbol, "Data mismatch error.")
    
    order.status = 2
    order.close_price = 100.00
    order.close_time = Time.now.to_s
    
    assert_nothing_raised("save failed."){
      result = @list.save(order)
    }
  end
end