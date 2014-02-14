require_relative "../price_feeds/price_feeds"

class Trader
  # Trader class will be called from Backtest
  #
  # "setup" method is for initial setup for Backtest.
  # "run" method will be called each bars.
  # "finalize" method will be call when backtest finished.
  #
  # In your own trader, you've got to inherit Trader class.
  # And set "setup", "run". "finalize" methods. 
  #
  # csv data must be stocked in data folder.
  # csv file name must be the same as trade symbol.
  
  def initialize(feeds)
    @feeds = feeds
  end
  
  # Initial setup to start backtest.
  # You must load historical data in this method.
  # - feed : A instance of PriceFeeds class
  def setup
    
  end
  
  # The action when you get a new bar.
  def run
    
  end
  
  # When finalize backtest.
  def finalize
    
  end
  
  def load(symbol)
    csv = "%s/../../data/%s.csv"%[File::dirname(__FILE__), symbol.to_s]
    @feeds.set_data(symbol, csv)
  end
end

# Load every trader
traders_path = File.expand_path("../../../traders", __FILE__)
Dir::foreach(traders_path) do |v|
  next if v == "." or v == ".."
  require_relative "%s/%s"%[traders_path, v]
end