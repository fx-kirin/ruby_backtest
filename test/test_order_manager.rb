require_relative "test_master"
require_relative "../lib/order_manager/order_manager"

class TestOrderManager < TestMaster
  def setup
    @manager = OrderManager.new
  end
  
  def test_now
    
  end
end