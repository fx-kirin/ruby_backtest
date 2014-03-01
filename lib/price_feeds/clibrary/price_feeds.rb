require_relative "history_center"
class Time
  def year
    rb_time_to_type(0, to_i)
  end
  
  def month
    rb_time_to_type(1, to_i)
  end
  
  def day
    rb_time_to_type(2, to_i)
  end
  
  def hour
    rb_time_to_type(3, to_i)
  end
  
  def minute
    rb_time_to_type(4, to_i)
  end
  
  def sec
    rb_time_to_type(5, to_i)
  end
  
  def wday
    rb_time_to_type(6, to_i)
  end
  
  def yday
    rb_time_to_type(7, to_i)
  end
end


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
    @history = HistoryCenter.new
  end
  
  # Set price data to the class.
  # - symbol : The symbol of data to be managed.
  def set_data(symbol)
    @history.load(symbol)
    @max_bars = @history.max_bars
    @bar[symbol] = 200
  end
  
  # Backtest will proceed on base pair basis.
  def set_base_symbol(symbol, date)
    @base_symbol = symbol
    if(time(symbol, 0) >= date)
      date = time(symbol, 0)
    end
    
    set_bar_from_date(symbol, date)
    @bar.keys.each{|sym|
      next if sym == @base_symbol
      set_bar_from_date(sym, get_real_chart_data(@base_symbol, :time, @bar[@base_symbol]))
    }
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
      set_bar_from_date(symbol, get_real_chart_data(@base_symbol, :time, @bar[@base_symbol]))
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
  
  def moving_average(symbol, type, period, bar)
    @history.moving_average(symbol, type, period, get_actual_bar(symbol, bar))
  end
  
  private
  def get_chart_data(symbol, data_type, bar)
    unless @bar.has_key?(symbol)
      raise "Symbol does not exists."
    end
    get_real_chart_data(symbol, data_type, get_actual_bar(symbol, bar))
  end
  
  def get_real_chart_data(symbol, data_type, bar)
    @history.get_data(symbol, bar, data_type)
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
    
    while(@bar[symbol] + 1 < @max_bars[symbol] && get_real_chart_data(symbol, :time, @bar[symbol] + 1) <= date)
      @bar[symbol] += 1
    end
    @bar[symbol]
  end
end