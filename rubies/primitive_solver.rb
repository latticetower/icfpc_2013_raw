require 'net/http'
require 'rubygems'
require 'json'

require "./problem"

h = Net::HTTP.new('icfpc2013.cloudapp.net')
#tr = TrainRequest.new(3, '')
#an algorithm is as follows: 
#1. first we get all problems with metadata
#2. second we load them to file
resp = h.post('/myproblems?auth=00306ooBUr4BvTjTrWJJyZfHXbwBVU2kLk1cipuAvpsH1H', nil)
puts "Code = #{resp.code}"
puts "Message = #{resp.message}"
puts "returns = #{resp.body}"
File.open('metadata.txt', 'w') do |f|
  f.puts resp.body
  
end

@arr = Problem.array_from_json(resp.body)
 
p @arr.keep_if{|problem| problem.solved }.count