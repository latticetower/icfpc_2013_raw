require 'net/http'
require 'rubygems'
require 'json'
require "./train_request"
require "./training_problem"
require "./guess"

def basic_training
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
end

def basic_guess(id, program)
  h = Net::HTTP.new('icfpc2013.cloudapp.net')
  g = Guess.new(id, program)
  #change train to guess in the following line if you are sure about work
  resp = h.post('/guess?auth=00306ooBUr4BvTjTrWJJyZfHXbwBVU2kLk1cipuAvpsH1H', g.to_json )
  puts "Code = #{resp.code}"
  puts "Message = #{resp.message}"
  puts "returns = #{resp.body}"
  resp.code
end