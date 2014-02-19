require_relative "../../../clibrary/history_data/history_data"

class HistoryCenter
  def initialize
    @history = HistoryData.new
    @symbols = Hash.new
  end
  
  def load(symbol)
    @symbols[symbol] = File.expand_path("../../../../data/" + symbol.to_s + ".hst", __FILE__)
  end
  
  private
  def get_symbol(symbol)
    
  end
end

require "pry"
binding.pry