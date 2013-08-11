require 'net/http'
require 'rubygems'
require 'json'

require "./problem"
require "./noisy_listener"
require "./solver_functions"


#h = Net::HTTP.new('icfpc2013.cloudapp.net')
#resp = h.post('/myproblems?auth=00306ooBUr4BvTjTrWJJyZfHXbwBVU2kLk1cipuAvpsH1H', nil)

f = File.open('metadata.txt') 
arr = f.gets #resp.body 
#sleep(4.1)
@arr = Problem.array_from_json(arr).select{|x| !x.solved && (x.time_left.nil? || x.time_left > 0) }

p @arr.size
counter = 0
@arr.each do |problem|
  if !problem.solved && (problem.time_left.nil? || problem.time_left>0)  && problem.operators.size < 3   
      #solve_for_operators_size4(problem) if problem.operators.size == 4 
       p "solving #{problem.id}"
       counter = counter + 1
      p "operators: [#{problem.operators.join(',')}]  #{problem.size} #{problem.solved} #{problem.time_left}"
  end
end
p counter
#problem = @arr[0] if @arr.size > 0

#if problem #&& problem.operators.size == 3
 #if problem #&& problem.operators.size == 3
   # solve_for_operators_size_m(problem) do |exp|
   #   p exp
  
    
  #  end
  #end
#end