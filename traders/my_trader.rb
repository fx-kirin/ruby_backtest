# This is sample trader.

class MyTrader < Trader
  def run
    #require "pry"
    #binding.pry
    ma20 = moving_average(@base_symbol, :close, 20, 0)  #mymoving_average(20, 0)
    ma100 = moving_average(@base_symbol, :close, 100, 0) #mymoving_average(100, 0)
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
  
  def mymoving_average(period, bar)
    return 20 if period == 20
    return 100 if period == 100
    ave = 0
    period.times{|i|
      ave += close(i+bar)
    }
    ave /= period
    ave
  end
end