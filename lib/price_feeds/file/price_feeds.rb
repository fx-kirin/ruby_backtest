require "csv"
require "sqlite3"
require "time"

class PriceFeeds
  class OutOfRangeException < RuntimeError; end
  PricePair = Struct.new(:time, :open, :close, :high, :low, :volume)
  
  # - date : Start time.
  # - base_symbol : Backtest will proceed on base pair basis.
  # - bar : Current bar number.
  # - pair : Trade pair list and data.
  def initialize(date = 0)
    @date = date
    @base_symbol = nil
    @bar = Hash.new
    @max_bars = Hash.new
    @db = SQLite3::Database.new(":memory:")
  end
  
  # Set price data to the class.
  # - symbol : The symbol of data to be managed.
  # - csv : Data list.
  def set_data(symbol, csv)
    @max_bars[symbol] = read_csv_data(symbol, csv)
    @bar[symbol] = 1
  end
  
  # Backtest will proceed on base pair basis.
  def set_base_symbol(symbol, date)
    @base_symbol = symbol
    set_bar_from_date(symbol, date)
  end

  def get_base_symbol
    @base_symbol
  end  

  # Go forward to next bar.
  def go_forward
    raise "Must set base_symbol first before call go forward" unless @base_symbol
    
    if @bar[@base_symbol] + 1 >= @max_bars[@base_symbol]
      raise(OutOfRangeException, "Out of range.") 
    end
    
    @bar[@base_symbol] += 1
    
    @bar.keys.each{|symbol|
      next if symbol == @base_symbol
      set_bar_from_date(symbol, get_ex_chart_data(@base_symbol, :time, @bar[@base_symbol]))
    }
  end
  
  # Get close price of indicated bar.
  # symbol : The symbol of data.
  # bar : The number of bar. If you want to use current bar, it's 0.
  def close(symbol, bar)
    get_chart_data(symbol, :close, bar)
  end
  
  def high(symbol, bar)
    get_chart_data(symbol, :high, bar)
  end
  
  def low(symbol, bar)
    get_chart_data(symbol, :low, bar)
  end
  
  def open(symbol, bar)
    get_chart_data(symbol, :open, bar)
  end
  
  def time(symbol, bar)
    get_chart_data(symbol, :time, bar)
  end
  
  def volume(symbol, bar)
    get_chart_data(symbol, :volume, bar)
  end
  
  private
  def read_csv_data(symbol, csv)
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS #{symbol.to_s} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        time text,
        open double,
        close double,
        high double,
        low double,
        volume int
      );
    SQL
    
    i=0
    IO.foreach(csv) do |line|
      i+=1
      res = line.split(",")
      insert_data(i, symbol, "%s %s"%[res[0], res[1]], res[2], res[3], res[4], res[5], res[6])
    end
    i
  end
  
  def insert_data(bar, symbol, time, open, close, high, low, volume)
    sql = "INSERT INTO #{symbol.to_s}(id, time, open, close, high, low, volume) VALUES(?, ?, ?, ?, ?, ?, ?)"
    @db.execute(sql, bar, time, open, close, high, low, volume)
  end
  
  def get_chart_data(symbol, data_type, bar)
    get_ex_chart_data(symbol, data_type, get_actual_bar(symbol, bar))
  end
  
  def get_ex_chart_data(symbol, data_type, bar)
    unless @bar.has_key?(symbol)
      raise "Symbol does not exists."
    end
    sql = "SELECT #{data_type.to_s} FROM #{symbol.to_s} WHERE id = ? LIMIT 1"
    result = @db.execute(sql, bar)
    raise "Out of range error" unless result.length > 0
    txt = result[0][0]
    case data_type
    when :time
      data = Time.parse(txt)
    when :volume
      data = txt.to_i
    else
      data = txt.to_f
    end
    data
  end
  
  def get_actual_bar(symbol, bar)
    if(bar < 0)
      raise "bar value must be plus."
    end
    actual_bar = @bar[symbol] - bar
    if(actual_bar < 0)
      raise "Your indicated bar is out of range."
    end
    actual_bar
  end
  
  # Search current bar which is not base symbol.
  def set_bar_from_date(symbol, date)
    if(@max_bars[symbol] <= @bar[symbol] + 1)
      return @bar[symbol]
    end
    
    while(@bar[symbol] + 1 < @max_bars[symbol] && get_ex_chart_data(symbol, :time, @bar[symbol] + 1) <= date)
      @bar[symbol] += 1
    end
    @bar[symbol]
  end
end