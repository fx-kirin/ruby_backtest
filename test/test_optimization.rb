# Test PriceFeeds
require_relative "test_master"
require_relative "../lib/optimization/optimization"

class TestOptimization < TestMaster
  def setup
  end

  def test_run
    start_date = Time.parse("2007.01.10 07:00")
    end_date = Time.parse("2007.03.30 07:00")
    opts = []
    opts << OptSetting.new("param1", 1, 1, 10)
    opts << OptSetting.new("param2", 2, 2, 20)
    opt = Optimization.new(TraderMock, opts, :USDJPY60, start_date, end_date, {:USDJPY60 => 0.003})
    opt.run
  end
  
  def test_make_param_array
    opts = []
    opts << OptSetting.new("param1", 1, 1, 10)
    opts << OptSetting.new("param2", 2, 2, 20)
    opts << OptSetting.new("param3", 3, 3, 30)
    opt = Optimization.new(TraderMock, opts)
    params = opt.make_param_array
    assert_equal(params.length, 1000, "length is wrong.")
    assert_equal(params[0]["param1"], 1, "param1 is wrong.")
    assert_equal(params[0]["param2"], 2, "param2 is wrong.")
    assert_equal(params[0]["param3"], 3, "param3 is wrong.")
    assert_equal(params[999]["param1"], 10, "param1 is wrong.")
    assert_equal(params[999]["param2"], 20, "param2 is wrong.")
    assert_equal(params[999]["param3"], 30, "param3 is wrong.")
  end
end