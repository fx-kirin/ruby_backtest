require "time"
require "csv"

class BacktestOrderList
  OrderList = Struct.new(:symbol, :order_type, :lots, :status, :open_price, :close_price, :stop_loss, 
                         :take_profit, :magic_number, :order_number, :open_time, :close_time, :profit)

  class NoDataFoundException < RuntimeError; end
  class OrderNumberIsNotNilException < RuntimeError; end
  
  def initialize
    @last_id = 0
    @open_orders = Array.new
    path = File.expand_path("../../../result/result.csv", __FILE__)
    @csv = CSV.open(path, "w")
    @csv << OrderList.members
  end
  
  def new_order
    OrderList.new
  end
  
  def insert_order(order)
    raise OrderNumberIsNotNilException, "order_number must be nil when you insert order." if order.order_number
    order.order_number = get_latest_id
    @open_orders << order
  end
  
  def save(order)
    param = ""
    ques = ""
    arg = []
    @open_orders.delete_if{|row|
      row.order_number == order.order_number
    }
    @csv << order.values
  end
  
  def get_all_positions
    @open_orders
  end
  
  def get_positions_by_magic_number(magic_number)
    if(magic_number == 0)
      @open_orders
    else
      @open_orders.select{|row|
        row.magic_number == magic_number
      }
    end    
  end
  
  def get_positions_by_order_number(order_number)
    @open_orders.select{|row|
      row.order_number == order_number
    }
  end
  
  private
  def get_latest_id
    @last_id += 1
  end
end