require 'net/http'
require 'rubygems'
require 'json'
require "./train_request"
require "./training_problem"
require "./guess"
require "./eval_request"
require "./eval_response"
require "./guess_response"


def request_train_eval(id, challenge, arguments)
  h = Net::HTTP.new('icfpc2013.cloudapp.net')
  tr = EvalRequest.new(id, challenge, arguments)
  resp = h.post('/eval?auth=00306ooBUr4BvTjTrWJJyZfHXbwBVU2kLk1cipuAvpsH1H', tr.to_json )
  puts "Code = #{resp.code}"
  puts "Message = #{resp.message}"
  puts "returns = #{resp.body}"
  tr2 = EvalResponse.from_json(resp.body)
  yield tr2 if block_given?
  tr2
end

def request_train_problem(size = 3, ops = [])
  h = Net::HTTP.new('icfpc2013.cloudapp.net')
  tr = TrainRequest.new(size, ops)
  resp = h.post('/train?auth=00306ooBUr4BvTjTrWJJyZfHXbwBVU2kLk1cipuAvpsH1H', tr.to_json )
  puts "Code = #{resp.code}"
  puts "Message = #{resp.message}"
  puts "returns = #{resp.body}"
  tr2 = TrainingProblem.from_json(resp.body)
  yield tr2 if block_given?
  tr2
end

def request_train_guess(id, program)
  h = Net::HTTP.new('icfpc2013.cloudapp.net')
  g = Guess.new(id, program)
  #change train to guess in the following line if you are sure about work
  resp = h.post('/guess?auth=00306ooBUr4BvTjTrWJJyZfHXbwBVU2kLk1cipuAvpsH1H', g.to_json )
  puts "Code = #{resp.code}"
  puts "Message = #{resp.message}"
  puts "returns = #{resp.body}"
  yield resp if block_given?
  return nil if resp.code == "412" 
  GuessResponse.from_json(resp.body)
end

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
  resp
end