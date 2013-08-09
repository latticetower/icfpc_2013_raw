require 'net/http'
require 'rubygems'
require 'json'

require "./problem"
require "./noisy_listener"

h = Net::HTTP.new('icfpc2013.cloudapp.net')
resp = h.post('/myproblems?auth=00306ooBUr4BvTjTrWJJyZfHXbwBVU2kLk1cipuAvpsH1H', nil)

#f = File.open('metadata.txt') 
arr = resp.body 
@arr = Problem.array_from_json(arr, 3)
@arr.each do |problem|
  p "solving #{problem.id}"
  if not problem.solved and not problem.time_left
    if problem.operators.size == 1
      expr = "(lambda (x) (#{problem.operators[0]} x))"
      result = basic_guess(problem.id, expr)
      break if result != "200"
      sleep(5)
    end
  end
end