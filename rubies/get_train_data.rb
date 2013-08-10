require 'net/http'
require 'rubygems'
require 'json'

require "./problem"
require "./noisy_listener"
require "./solver_functions"

##this script is for define server responce on timeouts. for testing purposes
train_response = request_train_problem(6)

#sleep(4.1)
#@arr = Problem.array_from_json(arr,6).select{|x| !x.solved }
@arr = []
p "size of array #{@arr.size}" if @arr && @arr.size > 0


problem = if @arr && @arr.size > 0
            @arr[0] 
          else
            Problem.new(train_response.id, train_response.size, train_response.operators)
          end 

if problem #&& problem.operators.size == 3
  p "solving #{problem.id}"
  p "operators: #{problem.operators}  #{problem.size} #{problem.solved} #{problem.time_left}"
  solve_for_operators_size_m(problem) do |exp|
    p exp
    result = request_train_guess(problem.id, exp)
    break if result.code == "412"
    while result.code == "429" do
      result = request_train_guess(problem.id, exp)
      p "REPLIT"
    end
    #if result != "200"
    #  puts 'ERROR ERROR'
    #  puts problem.id
    #  break
    #end
    #sleep(4.1)
    
  end
end