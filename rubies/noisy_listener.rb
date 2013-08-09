require 'net/http'

h = Net::HTTP.new('icfpc2013.cloudapp.net')
resp= h.post('/train?auth=00306ooBUr4BvTjTrWJJyZfHXbwBVU2kLk1cipuAvpsH1H', nil )
puts "Code = #{resp.code}"
puts "Message = #{resp.message}"
resp.each {|key, val| printf "%-14s = %-40.40s\n", key, val }
 
