require 'benchmark'
require "csv"
require "time"
require_relative "test_master"

class TestPriceFeeds < TestMaster
  def test_read_csv
    symbol = :USDJPY60
    csv = "%s/../data/%s.csv"%[File::dirname(__FILE__), symbol.to_s]
    i=0
    time = Time.now.to_f
    d = [10].pack("d")
    2500000.times do
    #IO.foreach(csv) do |line|
      #f.read(1)
      i+=1
      #res = line.split(",")
      print i.to_s + "\r" if i % 10000 == 0
      #Time.at(time)
      #res[2].to_f
      #res[3].to_f
      #res[4].to_f
      #res[5].to_f
      #res[6].to_i
      d.unpack("d")
      d.unpack("d")
      d.unpack("d")
      d.unpack("d")
      d.unpack("d")
      d.unpack("d")
    end
  end
end
