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
    
    order = set_open_data(order)
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
    
    order = set_close_data(order)
    
    assert_nothing_raised("save failed."){
      result = @list.save(order)
    }
  end
  
  def test_get_all_positions
    @list.delete_all_positions
    100.times{
      order = @list.new_order
      order = set_open_data(order)
      @list.insert_order(order)
    }
    positions = @list.get_all_positions
    assert_equal(positions.length, 100, "Positions must be 100.")
  end
  
  def test_get_positions_by_status
    @list.delete_all_positions
    100.times{
      order = @list.new_order
      order = set_open_data(order)
      @list.insert_order(order)
    }
    assert_equal(@list.get_open_positions.length, 100, "Open Positions must be 100.")
    assert_equal(@list.get_close_positions.length, 0, "Close Positions must be 0.")
    positions = @list.get_all_positions
    positions.each{|pos|
      set_close_data(pos)
      @list.save(pos)
    }
    assert_equal(@list.get_open_positions.length, 0, "Open Positions must be 100.")
    assert_equal(@list.get_close_positions.length, 100, "Close Positions must be 0.")
  end
  
  def test_get_position_by_magic_number
    @list.delete_all_positions
    100.times{
      order = @list.new_order
      order = set_open_data(order)
      @list.insert_order(order)
    }
    assert_equal(@list.get_positions_by_magic_number(1234).length, 100, "Positions must be 100.")
    assert_equal(@list.get_open_positions_by_magic_number(1234).length, 100, "Open Positions must be 100.")
    assert_equal(@list.get_close_positions_by_magic_number(1234).length, 0, "Close Positions must be 0.")
    positions = @list.get_positions_by_magic_number(1234)
    positions.each{|pos|
      set_close_data(pos)
      @list.save(pos)
    }
    assert_equal(@list.get_positions_by_magic_number(1234).length, 100, "Positions must be 100.")
    assert_equal(@list.get_open_positions_by_magic_number(1234).length, 0, "Open Positions must be 0.")
    assert_equal(@list.get_close_positions_by_magic_number(1234).length, 100, "Close Positions must be 100.")
  end
  
  def test_delete_all_positions
    order = @list.new_order
    order = set_open_data(order)
    @list.insert_order(order)
    
    @list.delete_all_positions
    assert_equal(@list.get_all_positions.length, 0, "Positions have not been deleted.")
  end
  
  private
  def set_open_data(order)
    order.symbol = "USDJPY"
    order.order_type = 1
    order.lots = 10
    order.status = 1
    order.open_price = 100.10
    order.stop_loss = 99.00
    order.take_profit = 101.90
    order.open_time = Time.parse("2007.01.02 07:00")
    order.magic_number = 1234
    order
  end
  
  def set_close_data(order)
    order.status = 2
    order.close_price = 100.00
    order.close_time = Time.parse("2007.01.02 07:00")
    order
  end
end