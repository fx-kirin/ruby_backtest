require_relative "../backtest/backtest"

OptSetting = Struct.new(:name, :start, :step, :stop)

class Optimization
  def initialize(trader, opt_settings, symbol, start_date, end_date, spread_list)
    @trader = trader
    @opt_settings = opt_settings
    @symbol = symbol
    @start_date = start_date
    @end_date = end_date
    @spread_list = spread_list
  end
  
  def run
    delete_opt_result_file
    
    params = make_param_array
    
    length = params.length
    params.each_with_index{|param, i|
      print "Working with %d / %d                \r"%[i+1, length]
      backtest = Backtest.new(@trader, param)
      backtest.run(@symbol, @start_date, @end_date, @spread_list)
    }
  end
  
  def make_param_array(i=0, param_array = {}, whole_param = [])
    if @opt_settings.length > i
      opt = @opt_settings[i]
      rep = 0
      while true
        value = opt.start + opt.step*rep
        break if value > opt.stop 
        rep += 1
        param_array[opt.name] = value
        make_param_array(i+1, param_array, whole_param)
      end
    else
      whole_param << param_array.clone
    end
    return whole_param if(i == 0)
    return param_array
  end
  
  def delete_opt_result_file
    path = File.expand_path("../../../result/opt_#{@trader.to_s}.csv", __FILE__)
    File.delete(path) if File.exists?(path)
  end
end