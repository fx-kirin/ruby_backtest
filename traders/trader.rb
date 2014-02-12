class Trader
  # Trader class will be called from Backtest
  #
  # "setting" method is for initial setting for Backtest.
  # "start" method will be called each bars.
  # "finishing" method will be call when backtest finished.
  #
  # In your own trader, you've got to inherit Trader class.
  # And set "setting", "start". "finishing" methods. 
  #
  # csv data must be stocked in data folder.
  # csv file name must be the same as trade symbol.
  
  def initialize(feed)
    @feed = feed
  end
  
  # Initial setting to start backtest.
  # You must load historical data in this method.
  # - feed : A instance of PriceFeeds class
  def setting
    
  end
  
  # The action when you get a new bar.
  def start
    
  end
  
  # When finishing backtest.
  def finishing
    
  end
  
  def load(pair_name)
    csv = "%s/../data/%s.csv"%[File::dirname(__FILE__), pair_name]
    @feed.set_data(pair_name.to_sym, csv)
  end
end