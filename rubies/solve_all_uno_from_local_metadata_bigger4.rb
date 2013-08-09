require 'net/http'
require 'rubygems'
require 'json'

require "./problem"
require "./noisy_listener"

UNARIES = ["not", "shl1", "shr1", "shr4", "shr16"]
BINARIES = ["and", "or", "xor", "plus"]
h = Net::HTTP.new('icfpc2013.cloudapp.net')
#resp = h.post('/myproblems?auth=00306ooBUr4BvTjTrWJJyZfHXbwBVU2kLk1cipuAvpsH1H', nil)

f = File.open('metadata.txt') 
arr = f.gets #resp.body 
@arr = Problem.array_from_json(arr, 6, UNARIES)

p @arr.size
@arr.each do |problem|

  p "solving #{problem.id}"
  p "operators: #{problem.operators} #{problem.size}"
  if not problem.solved 
    if problem.size == 5
    exps = [
       "(lambda (x) (#{problem.operators[0]} (#{problem.operators[1]} (#{problem.operators[2]} x))))",
       "(lambda (x) (#{problem.operators[0]} (#{problem.operators[2]} (#{problem.operators[1]} x))))",
       "(lambda (x) (#{problem.operators[1]} (#{problem.operators[0]} (#{problem.operators[2]} x))))",
       "(lambda (x) (#{problem.operators[1]} (#{problem.operators[2]} (#{problem.operators[0]} x))))",       
       "(lambda (x) (#{problem.operators[2]} (#{problem.operators[0]} (#{problem.operators[1]} x))))",
       "(lambda (x) (#{problem.operators[2]} (#{problem.operators[1]} (#{problem.operators[0]} x))))",
      ].each do |exp|
        p exp
        result = basic_guess(problem.id, exp)
        if result!="200"
          puts 'ERROR ERROR'
          puts problem.id
          break
        end
      sleep(5)
      end
    end
    if problem.size == 6

      problem.operators.repeated_permutation(4) do |perm| 
        expr = "(lambda (x) (#{perm.join(' (')} x)))))"
        result = basic_guess(problem.id, expr)
        if result != "200"
          puts 'ERROR ERROR'
          puts problem.id
          break
        end
        sleep(5)
      end


    end
    
  end
end