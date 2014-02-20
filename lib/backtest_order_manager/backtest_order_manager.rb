require_relative "backtest_order_list"

class BacktestOrderManager
  # This class allow you to execute orders.
  OrderLong = 1
  OrderShort = 2
  
  def initialize
    @list = BacktestOrderList.new
    @open_orders = Array.new
  end
  
  def open_order(symbol, order_type, open_price, lots, take_profit, stop_loss, magic_number, open_time)
    order = @list.new_order
    order.symbol = symbol
    order.order_type = order_type
    order.open_price = open_price
    order.lots = lots
    order.take_profit = take_profit
    order.stop_loss = stop_loss
    order.magic_number = magic_number
    order.open_time = open_time
    order.status = 1
    order = @list.insert_order(order)
  end
  
  def close_order(order_number, close_price, close_time)
    order = get_positions_by_order_number(order_number)[0]
    order.close_price = close_price
    order.close_time = close_time
    order.status = 2
    if order.order_type == OrderLong
      order.profit = order.close_price - order.open_price
    elsif order.order_type == OrderShort
      order.profit = order.open_price - order.close_price
    end
    order.profit *= order.lots
    order.profit = order.profit.round(8)
    @list.save(order)
  end
  
  # Unused.
  def order_modify(order_number, stop_loss, take_profit)
    order = @list.get_position(order_number)
    order.stop_loss = stop_loss
    order.take_profit = take_profit
    @list.save(order)
  end
  
  def get_positions(magic_number)
    get_positions_by_magic_number(magic_number)
  end
  
  def get_open_positions(magic_number)
    get_positions_by_magic_number(magic_number)
  end
  
  def get_all_positions
    @list.get_all_positions
  end
  
  def get_positions_by_magic_number(magic_number)
    @list.get_positions_by_magic_number(magic_number)
  end
  
  def get_positions_by_order_number(order_number)
    @list.get_positions_by_order_number(order_number)
  end
end