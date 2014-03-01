# -*- coding: utf-8 -*-
require "kconv"
require "time"
require "pry"
require "csv"
require_relative "web_client"
require_relative "convert_csv"

cl = WebClient.new()
# Banks
#stock_nums = ["8303", "8304", "8306", "8308", "8309", "8316", "8331", "8332", "8354", "8355", "8411"]
# Medicine
#stock_nums = ["4151", "4502", "4503", "4506", "4507", "4519", "4523", "4568"]
# All
stock_numss = CSV.read(File.expand_path("../../data/list/whole_stock_list.csv", __FILE__))
find = false
stock_numss.each{|stock_nums|
  stock_nums.each{|stock_num|
    begin
      find = true if stock_num == "8958"
      next unless find
      puts stock_num + " is converting...."
      path = File.expand_path("../../data/csv/JP" + stock_num + ".csv", __FILE__)
      f = File.open(path, "w")
      2014.downto(2007){|year|
        cl.get("http://k-db.com/site/jikeiretsu.aspx?c=#{stock_num}-T&hyouji=a&year=#{year.to_s}&download=csv")
        html = cl.page.body.toutf8
        i=0
        html = html.gsub("前場", "09:00")
        html = html.gsub("後場", "12:30")
        html.lines{|line|
          i+=1
          next if i <= 2
          f.write("\n") unless i == 3
          f.write(line.chomp.tosjis)
        }
      }
      f.close
      csv = CSV.read(path)
      result = csv.sort_by{|a|
          Time.parse(a[0] + " " +a[1])
      }
      
      csv = CSV.open(path, "w")
      result.each{|row|
        csv << row
      }
      csv.close
      convert_csv(path)
      
      sleep 3
    rescue
      puts $!
      unless $!.class == CSV::MalformedCSVError
        sleep 60*5
        retry
      end
    end
  }
}