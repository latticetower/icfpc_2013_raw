require 'net/http'
require 'rubygems'
require 'json'

require "./problem"
require "./noisy_listener"

UNARIES = ["not", "shl1", "shr1", "shr4", "shr16"]
BINARIES = ["and", "or", "xor", "plus"]


def solve_for_operators_size3(problem)
  p "HELLO"
  c =0
  #we select how many binary operators in array + 1
  n = problem.operators.count{|x| BINARIES.include? x }
  variables = ['x', '0', '1'].repeated_permutation(n + 1)
  problem.operators.permutation(3).each do |perm|
    variables.each do |vars|
      exp = '(' + perm.reverse.join(' (') + ' ' + vars[0]
        c = c+1
        var_counter = 1
        perm.each do |op|
          if BINARIES.include? op
            exp = exp + ' ' + vars[var_counter] + ')'
            var_counter = var_counter + 1
          else
            exp = exp + ')'
          end

        end
        exp = "(lambda(x) #{exp})"# resulting formula. now correctly works for binary and unary operators
        yield exp if block_given? #optionally sends result to a block
       # p exp
    end   
  end
  p "total number of permutations: #{c}"
end

def solve_for_operators_size4(problem)
  return if problem.solved
  problem.operators.permutation(4) do |perm|
    exp = "(lambda (x) (#{perm.join(' (')} x)))))"
    result = basic_guess(problem.id, exp)
    if result!="200"
      puts 'ERROR ERROR'
      puts problem.id
      break
      end
    sleep(5)
  end
end