# This is sample trader.

class MyTrader < Trader
  def run
    ma20 = moving_average(@base_symbol, :close, 20, 1)
    ma100 = moving_average(@base_symbol, :close, 100, 1)
    if(ma20>ma100)
      unless order_exists?(1235)
        open_order(base_symbol, OrderShort, 5, 0, 0, 1235)
      end
      if order_exists?(1234)
        order = get_order(1234)
        close_order(order)
      end
    elsif(ma20<ma100)
      unless order_exists?(1234)
        open_order(base_symbol, OrderLong, 10, 0, 0, 1234)
      end
      if order_exists?(1235)
        order = get_order(1235)
        close_order(order)
      end
    end
  end
end