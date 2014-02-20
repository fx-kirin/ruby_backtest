require "csv"
require "pry"
require "time"

csv = ARGV[0]
digits = ARGV[1]

csv = "../test/sample_data/USDJPY60.csv" unless csv
digits = 5 unless digits

file_name = File.basename(csv).match(/(.*)\.([^.]+)$/)[1]
path = File.expand_path("../../data/hst/" + file_name + ".hst", __FILE__)
file = File.open(path, "wb")

# symbol
file.write(["USDJPY60"].pack("Z256"))
# digits
file.write([digits.to_i].pack("L"))
File.open(csv){|f|
  file.write([f.readlines.size].pack("Q"))
}
CSV.foreach(csv){|row|
  time = Time.parse(row[0] + " " + row[1])
  file.write([time.to_i].pack("l"))
  file.write([time.usec].pack("l"))
  file.write([row[2].to_f].pack("d"))
  file.write([row[3].to_f].pack("d"))
  file.write([row[4].to_f].pack("d"))
  file.write([row[5].to_f].pack("d"))
  file.write([row[6].to_i].pack("l"))
}

file.close