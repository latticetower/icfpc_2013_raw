require 'net/http'
require 'rubygems'
require 'json'

require "./problem"
require "./noisy_listener"

UNARIES = ["not", "shl1", "shr1", "shr4", "shr16"]
BINARIES = ["and", "or", "xor", "plus"]
h = Net::HTTP.new('icfpc2013.cloudapp.net')
resp = h.post('/myproblems?auth=00306ooBUr4BvTjTrWJJyZfHXbwBVU2kLk1cipuAvpsH1H', nil)

#f = File.open('metadata.txt') 
arr = resp.body 
@arr = Problem.array_from_json(arr, 4, UNARIES)

p @arr.size
@arr.each do |problem|

  p "solving #{problem.id}"
  p "operators: #{problem.operators} #{problem.size}"
  if not problem.solved 
    if problem.operators.size == 1
     expr = "(lambda (x) (#{problem.operators[0]} (#{problem.operators[0]} x)))"
     puts expr
     result = basic_guess(problem.id, expr)
    if result != "200"
      puts 'ERROR ERROR'
      puts p.id
      break
    end
      sleep(5)
    end
    if problem.operators.size == 2
     expr = "(lambda (x) (#{problem.operators[1]} (#{problem.operators[0]} x)))"
     puts expr
     result = basic_guess(problem.id, expr)
    if result != "200"
      expr = "(lambda (x) (#{problem.operators[1]} (#{problem.operators[0]} x)))"
      result = basic_guess(problem.id, expr)
      if result!="200"
        puts 'ERROR ERROR'
        puts p.id
        break
      end
    end
      sleep(5)
    end
  end
end