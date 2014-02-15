require "sqlite3"
require "time"

class BacktestOrderList
  OrderList = Struct.new(:symbol, :order_type, :lots, :status, :open_price, :close_price, :stop_loss, 
                         :take_profit, :magic_number, :order_number, :open_time, :close_time, :profit)

  class NoDataFoundException < RuntimeError; end
  class OrderNumberIsNotNilException < RuntimeError; end
  
  def initialize
    @db = SQLite3::Database.new File.expand_path("../../../db", __FILE__) + "/backtest_order_list.sqlite3"
    rows = @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS backtest_order_list (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        symbol text,
        order_type int,
        lots int,
        status int,
        open_price double,
        close_price double,
        stop_loss double,
        take_profit double,
        magic_number int,
        order_number int,
        open_time text,
        close_time text,
        profit double
      );
    SQL
    get_latest_id
  end
  
  def new_order
    OrderList.new
  end
  
  def insert_order(order)
    raise OrderNumberIsNotNilException, "order_number must be nil when you insert order." if order.order_number
    order.order_number = get_latest_id + 1
    
    param = ""
    ques = ""
    arg = []
    order.members.each{|mem|
      param += mem.to_s + ","
      ques += "?,"
      case(mem)
      when :open_time, :close_time
        arg << order.send(mem).strftime('%H:%M:%S.%6N') if order.send(mem) != nil && order.send(mem) != ""
      else
        arg << order.send(mem).to_s
      end
    }
    param.slice!(param.length-1, 1)
    ques.slice!(ques.length-1, 1)
    
    result = @db.execute("INSERT INTO backtest_order_list(#{param}) VALUES(#{ques})", arg);
    order
  end
  
  def get_position(order_number)
    param = set_select_param
    result = @db.execute("SELECT #{param} FROM backtest_order_list WHERE order_number=?", order_number);
    raise NoDataFoundException, "Nothing is matched with order_number" if result.length == 0
    order = set_order_from_data(result[0])
    order
  end
  
  def save(order)
    param = ""
    arg = []
    order.members.each{|mem|
      param += mem.to_s + "=?,"
      arg << order.send(mem).to_s
    }
    param.slice!(param.length-1, 1)
    arg << order.order_number
    
    result = @db.execute("UPDATE backtest_order_list SET #{param} WHERE order_number=?", arg);
  end
  
  def get_all_positions(where="")
    positions = []
    param = set_select_param
    result = @db.execute("SELECT #{param} FROM backtest_order_list "+where);
    result.each{|data|
      positions << set_order_from_data(data)
    }
    positions
  end
  
  def get_open_positions
    get_all_positions(where="WHERE status = 1")
  end

  def get_close_positions
    get_all_positions(where="WHERE status = 2")
  end
  
  def get_positions_by_magic_number(magic_number)
    get_all_positions(where="WHERE magic_number = "+magic_number.to_s)
  end
  
  def get_open_positions_by_magic_number(magic_number)
    get_all_positions(where="WHERE status = 1 AND magic_number = "+magic_number.to_s)
  end

  def get_close_positions_by_magic_number(magic_number)
    get_all_positions(where="WHERE status = 2 AND magic_number = "+magic_number.to_s)
  end
  
  def delete_all_positions
    @db.execute("DELETE FROM backtest_order_list");
  end
  
  private
  def get_latest_id
    index = @db.execute("SELECT MAX(order_number) FROM backtest_order_list")[0][0]
    index ? index : 0
  end
  
  def set_select_param
    param = ""
    OrderList.members.each{|mem|
      param += mem.to_s + ","
    }
    param.slice!(param.length-1, 1)
    param
  end
  
  def set_order_from_data(data)
    order = OrderList.new
    order.members.each_with_index{|mem, i|
      case(mem)
      when :symbol
        order.send(mem.to_s+"=", data[i].to_sym)
      when :order_type, :lots, :status, :magic_number, :order_number
        order.send(mem.to_s+"=", data[i].to_i)
      when :open_price, :close_price, :stop_loss, :take_profit, :profit
        order.send(mem.to_s+"=", data[i].to_f)
      when :open_time, :close_time
        order.send(mem.to_s+"=", Time.parse(data[i])) if data[i] != nil && data[i] != ""
      else
        order.send(mem.to_s+"=", data[i])
      end
    }
    order
  end
end