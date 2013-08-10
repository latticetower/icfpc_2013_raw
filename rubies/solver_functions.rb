require 'net/http'
require 'rubygems'
require 'json'

require "./problem"
require "./noisy_listener"

UNARIES = ["not", "shl1", "shr1", "shr4", "shr16"]
BINARIES = ["and", "or", "xor", "plus"]


def solve_for_operators_size3(problem)
  p "HELLO"
end

def solve_for_operators_size4(problem)
  return if problem.solved
  p "HELLO1"
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