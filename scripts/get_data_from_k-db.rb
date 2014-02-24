# -*- coding: utf-8 -*-
require "kconv"
require "time"
require "pry"
require "csv"
require_relative "web_client"

cl = WebClient.new()
stock_num = "9984"
path = File.expand_path("../../data/csv/nihon" + stock_num + ".csv", __FILE__)
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
result = csv.sort_by{|a|Time.parse(a[0] + " " +a[1])}

csv = CSV.open(path, "w")
result.each{|row|
  csv << row
}
csv.close