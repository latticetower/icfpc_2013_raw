require 'net/http'
require 'rubygems'
require 'json'

require "./problem"
require "./noisy_listener"
require "./solver_functions"

UNARIES = ["not", "shl1", "shr1", "shr4", "shr16"]
BINARIES = ["and", "or", "xor", "plus"]
#h = Net::HTTP.new('icfpc2013.cloudapp.net')
#resp = h.post('/myproblems?auth=00306ooBUr4BvTjTrWJJyZfHXbwBVU2kLk1cipuAvpsH1H', nil)

f = File.open('metadata.txt') 
arr = f.gets #resp.body 
@arr = Problem.array_from_json(arr,6)

p @arr.size

@arr.each do |problem|
  if !problem.solved && (problem.time_left.nil? || problem.time_left>0)
    p "solving #{problem.id}"
    p "operators: #{problem.operators}  #{problem.size} #{problem.solved} #{problem.time_left}"
   
      solve_for_operators_size3(problem) if problem.operators.size == 3
      solve_for_operators_size4(problem) if problem.operators.size == 4
  end
end


