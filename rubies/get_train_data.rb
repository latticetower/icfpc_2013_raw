require 'net/http'
require 'rubygems'
require 'json'

require "./problem"
require "./noisy_listener"
require "./solver_functions"
require "./eval_request"
require "./eval_response"
require "./basic_evaluator"
  
  def get_problem(size)
    ##this script is for define server responce on timeouts. for testing purposes
    train_response = request_train_problem(size)

    #sleep(4.1)
    #@arr = Problem.array_from_json(arr,6).select{|x| !x.solved }
    @arr = []
    p "size of array #{@arr.size}" if @arr && @arr.size > 0
    problem = if @arr && @arr.size > 0
                @arr[0] 
              else
                Problem.new(train_response.id, train_response.size, train_response.operators)
              end 
              problem
  end

def generate_array
  format = "%#016x"
  a = []
  64.times do |i|
    a << format % (0x1 << i)
  end
  63.times do |i|
    a << format % (0x3 << i)
  end
  a << format % 0xFFFFFFFFFFFFFFFF
  62.times do |i|
    a << format % (0x7 << i)
  end
  a << format % "0x7FFFFFFFFFFFFFFF" << format % "0xFFFFFFFFFFFFFFFE"
  61.times do |i|
    a << format % (0xF << i)
  end
  a << format % "0x3FFFFFFFFFFFFFFF" << format % "0x7FFFFFFFFFFFFFFE" << format % "0xFFFFFFFFFFFFFFFC"
  a
end
def format_number(e)
  "%#016x" % e
end

def eval_train_data_and_send_them_to_file
  @f = File.new("test_data#{train_response.id}.txt", 'w')
  
  @f.puts "solving #{train_response.id}"
  @f.puts "size: #{train_response.size}, operators: #{train_response.operators.join(', ')}"
  @f.puts "challenge: #{train_response.challenge}"


  request_array = generate_array
  @f.puts ' request: [' + request_array.join(', ') + ']'
  request_train_eval(nil, train_response.challenge, request_array) do |resp|
    @f.puts "response status: #{resp.status}"
    @f.puts("response array: [" + resp.outputs.join(', ') + ']') if resp.outputs
    @f.puts(resp.message) if resp.message
  end
  @f.close
end

def solve_and_send_to_server(problem)
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
    end
end

@data_array = []
def solve_and_send_to_file(problem)
    p "solving #{problem.id}"
    p "operators: #{problem.operators}  #{problem.size} #{problem.solved} #{problem.time_left}"

    solve_for_operators_with_conditional(problem) do |exp|
      be = BasicEvaluator.new(exp)
      c = be.calculate(0)
      @data_array  << be      
    end
end

problem = get_problem(6)
exit if (problem.operators & ['fold', 'tfold']).size > 0
request1 = generate_array()
solve_and_send_to_file(problem)

request_train_eval(problem.id, nil, request1) do |resp|

  @data_array
  request1.size.times do |i|
    @data_array = @data_array.keep_if{|x| format_number(resp.outputs[i].to_i(16)) == format_number(x.calculate(request1[i].to_i(16)))}
    break if @data_array.size <= 1
  end
  if @data_array.size < 1
    p 'ERROR SCARY ERROR!!!!!!12'
    
  end
  if @data_array.size ==1
    p "solution must be " + @result_functions[0].formula

  end
  p @data_array.count
  p "end"

end

@data_array.each do |func|
  r = request_train_guess(problem.id, func.formula)
  break if r.nil?
  if r.status == "win"
    p "SOLVED"
    break
  end
end

#be = BasicEvaluator.new("(lambda(x) " + build_string(['shr1', 'not', 'plus', 'x', 'x'])+")")
#p format_number(be.calculate(0))