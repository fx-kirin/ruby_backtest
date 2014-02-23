require_relative "../../../clibrary/history_data/history_data"

class HistoryCenter
  class HistoryFileNotExist < RuntimeError; end
  class OutOfRangeException < RuntimeError; end
  
  # Data type from c library
  DataString = 0
  DataFixnum = 1
  DataFloat = 2
  DataTime = 3
  
  def initialize
    @history = HistoryData.new
    @indexes = Hash.new
    @max_bars = Hash.new
    @digits = Hash.new
  end
  
  def load(symbol)
    filepath = File.expand_path("../../../../data/hst/" + symbol.to_s + ".hst", __FILE__)
    unless File.exists?(filepath)
      raise HistoryFileNotExist, "History file doens't exist."
      return
    end
    @indexes[symbol] = @history.load(filepath)
    @max_bars[symbol] = get_max_bars(symbol)
    @digits[symbol] = get_digits(symbol)
  end
  
  def get_data(symbol, bar, type)
    raise OutOfRangeException, "Out of range." if bar >= @max_bars[symbol]
    
    pos = 268 + bar * 44
    case(type)
    when :time
      @history.get(DataTime, @indexes[symbol], pos, 8)
    when :open
      @history.get(DataFloat, @indexes[symbol], pos+8, 8)
    when :high
      @history.get(DataFloat, @indexes[symbol], pos+16, 8)
    when :low
      @history.get(DataFloat, @indexes[symbol], pos+24, 8)
    when :close
      @history.get(DataFloat, @indexes[symbol], pos+32, 8)
    when :volume
      @history.get(DataFixnum, @indexes[symbol], pos+40, 4)
    end
  end
  
  def moving_average(symbol, type, period, bar)
    pos = 268 + bar * 44
    result = nil
    case(type)
    when :open
      result = @history.moving_average(@indexes[symbol], pos+8, period)
    when :high
      result = @history.moving_average(@indexes[symbol], pos+16, period)
    when :low
      result = @history.moving_average(@indexes[symbol], pos+24, period)
    when :close
      result = @history.moving_average(@indexes[symbol], pos+32, period)
    end
    result
  end
  
  def max_bars
    @max_bars
  end
  
  private
  def get_symbol(symbol)
    
  end
  
  def get_max_bars(symbol)
    @history.get(DataFixnum, @indexes[symbol], 260, 8)
  end
  
  def get_digits(symbol)
    @history.get(DataFixnum, @indexes[symbol], 256, 4)
  end
end