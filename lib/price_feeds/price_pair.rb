# PricePair is the main structure of price chart.

class PricePair
  attr_reader :open, :close, :high, :low, :time, :volume
  
  def initialize
    @open  = []
    @close = []
    @high  = []
    @low   = []
    @time  = []
    @volume = []
  end
end