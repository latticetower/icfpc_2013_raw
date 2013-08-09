require 'net/http'
require 'rubygems'
require 'json'
require "./train_request"
require "./training_problem"

h = Net::HTTP.new('icfpc2013.cloudapp.net')
tr = TrainRequest.new(3, '')
resp= h.post('/train?auth=00306ooBUr4BvTjTrWJJyZfHXbwBVU2kLk1cipuAvpsH1H', tr.to_json )
puts "Code = #{resp.code}"
puts "Message = #{resp.message}"
puts "returns = #{resp.body}"
resp.each {|key, val| printf "%-14s = %-40.40s\n", key, val }
 

tr2 = TrainingProblem.from_json(resp.body)
p tr2.to_json
p tr2.challenge