require_relative "../../traders/trader"

class TraderMock < Trader
  def setting
    load("USDJPY60")
  end
  
  def start
    
  end
  
  def finishing
    
  end
end