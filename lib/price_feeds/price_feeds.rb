require "csv"
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
    @pair = Hash.new
  end
  
  # Set price data to the class.
  # - symbol : The symbol of data to be managed.
  # - csv : Data list.
  def set_data(symbol, csv)
    @pair[symbol] = read_csv_data(csv)
    @bar[symbol] = 0
  end
  
  # Backtest will proceed on base pair basis.
  def set_base_symbol(symbol, date)
    @base_symbol = symbol
    set_bar_from_date(symbol, date)
  end
  
  # Go forward to next bar.
  def go_forward
    raise "Must set base_symbol first before call go forward" unless @base_symbol
    
    if @bar[@base_symbol] + 1 >= @pair[@base_symbol].length
      raise(OutOfRangeException, "Out of range.") 
    end
    
    @bar[@base_symbol] += 1
    
    @pair.keys.each{|symbol|
      next if symbol == @base_symbol
      set_bar_from_date(symbol, @pair[@base_symbol][@bar[@base_symbol]].time)
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
  def read_csv_data(csv)
    feed = Array.new
    CSV.foreach(csv){|row|
      pair = PricePair.new
      pair.time = Time.parse("%s %s"%[row[0], row[1]])
      pair.open = row[2].to_f
      pair.close = row[3].to_f
      pair.high = row[4].to_f
      pair.low = row[5].to_f
      pair.volume = row[6].to_i
      feed << pair
    }
    feed
  end
  
  def get_chart_data(symbol, data_type, bar)
    unless @pair.has_key?(symbol)
      raise "Symbol does not exists."
    end
    @pair[symbol][get_actual_bar(symbol, bar)].send(data_type)  
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
    if(@pair[symbol].length <= @bar[symbol] + 1)
      return @bar[symbol]
    end
    
    while(@bar[symbol] + 1 < @pair[symbol].length && @pair[symbol][@bar[symbol] + 1].time <= date)
      @bar[symbol] += 1
    end
    @bar[symbol]
  end
end