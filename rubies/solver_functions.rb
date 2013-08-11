require 'net/http'
require 'rubygems'
require 'json'

require "./problem"
require "./noisy_listener"
require "./eval_request"
require "./eval_response"

UNARIES = ["not", "shl1", "shr1", "shr4", "shr16"]
BINARIES = ["and", "or", "xor", "plus"]

def solver_cycle(problem)
  if problem && problem.operators.size == 3
    solve_for_operators_size_m(problem) do |exp|
      p exp
      result = basic_guess(problem.id, exp)
      break if result.code == "412" || result.code == "410"
      while result.code == "429" do
        result = request_train_guess(problem.id, exp)
        p "REPLIT"
      end
    
    end
  end
end

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

def solve_for_operators_size_m(problem)
  p "in solver function"
  c =0

  #we select how many binary operators in array + 1
  n = problem.operators.count{|x| BINARIES.include? x }
  m = problem.size - 2 - n

  
  problem.operators.repeated_permutation(m).each do |perm|
    next if (perm & problem.operators).size != problem.operators.size
    variables = ['x', '0', '1'].repeated_permutation(perm.count{|x| BINARIES.include? x } + 1)
    variables.each do |vars|
      exp = '(' + perm.reverse.join(' (') + ' ' + vars[0]
        c = c + 1
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
  p "solver function ends. total number of permutations: #{c}"
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
#
#


def build_perm_string(perm, vars, i, j)
  return ["#{vars[j]}"] if i >= perm.size && j < vars.size
  return [''] if i >= perm.size && j >= vars.size
  if BINARIES.include? perm[i]
    s1 = build_perm_string(perm, vars, i + 1, j + 1)
    if s1.nil?
      return nil
    else
      return s1.map do |s|
        [
          "(#{perm[i]} #{s} #{vars[j]})",
          "(#{perm[i]} #{vars[j]} #{s})"
        ]
      end.flatten
    end
  end
  if UNARIES.include? perm[i]
    s1 = build_perm_string(perm, vars, i + 1, j)
    if s1.nil?
      return nil
    else
      return s1.map do |s|
        [
          "(#{perm[i]} #{s} #{vars[j]})"
        ]
      end.flatten
    end
  end
  if perm[i] == "if0"
    p "#{i + j} #{perm.size + vars.size - 3}"
   #return nil if i + j >= perm.size + vars.size - 3
    s1 = build_perm_string(perm, vars, i + 1, j)
    return s1.map do |s|
      [
        "(#{perm[i]} #{s})"
      ]
    end.flatten
  end
end


##works ok for binaries and unaries

def solve_for_operators_size_m_vars(problem)
  p "in solver function"
  c =0

  #we select how many binary operators in array + 1
  n = problem.operators.count{|x| BINARIES.include? x }
  n3 = problem.operators.count{|x| x == "if0"}
  m = problem.size - 1 - (n + 1) - (n3 + 1)

  
  problem.operators.repeated_permutation(m).each do |perm|
    next if (perm & problem.operators).size != problem.operators.size
    variables = ['x', '0', '1'].repeated_permutation(perm.count{|x| BINARIES.include? x } + 1)
    variables.each do |vars|
      s = build_perm_string(perm, vars, 0, 0) || []
      c = c + s.size
      s.each do |str|  
        exp = "(lambda(x) #{str})"# resulting formula. now correctly works for binary and unary operators
        yield exp if block_given? #optionally sends result to a block
      end
    end   
  end
  p "solver function ends. total number of permutations: #{c}"
end

def build_string(all_vars)
  s = ''
  open_braces = 0
  terms = []
  all_vars.size.times do |i|

    if UNARIES.include? all_vars[i]
      terms.push 1
      open_braces = open_braces + 1
      s = s + " (" + all_vars[i]
    end
    if BINARIES.include? all_vars[i]
      terms.push 2
      open_braces = open_braces + 1
      s = s + " (#{all_vars[i]}"

    end
    if "if0" == all_vars[i]
      terms.push 3
      open_braces = open_braces + 1
      s = s + " (" + all_vars[i]
    end
    unless (UNARIES + BINARIES + ["if0"]).include? all_vars[i]
      num = terms.pop

      return nil if num.nil?

      s = s + " " + all_vars[i]

      while num == 1 do
        s = s + ')'
        open_braces = open_braces - 1
        return nil if open_braces < 0
        num = terms.pop
        
      end
      if num && num > 1
        terms.push(num - 1)
      end
    end

  end 
  while open_braces > 0 && terms.size > 0 do
    s = s + ")"
    open_braces = open_braces - 1
    t = terms.pop
    return nil if t
  end
  s.lstrip
#
end

def rebuild_string(all_vars)
  s = ''
  open_braces = 0
  terms = []
  all_vars.size.times do |i|
    if UNARIES.include? all_vars[i]
      terms.push 1
      open_braces = open_braces + 1
      s = s + " (" + all_vars[i]
    end
    if BINARIES.include? all_vars[i]
      terms.push 2
      open_braces = open_braces + 1
      s = s + " (#{all_vars[i]}"
    end
    if "if0" == all_vars[i]
      terms.push 3
      open_braces = open_braces + 1
      s = s + " (" + all_vars[i]
    end
    unless (UNARIES + BINARIES + ["if0"]).include? all_vars[i]
      num = terms.pop

      return nil if num.nil?

      s = s + " " + all_vars[i]

      while num == 1 do
        s = s + ')'
        open_braces = open_braces - 1
        return nil if open_braces < 0
        num = terms.pop
        
      end
      if num && num > 1
        terms.push(num - 1)
        s = s + ", "
      end
    end

  end 
  while open_braces > 0 && terms.size > 0 do
    s = s + ")"
    open_braces = open_braces - 1
    t = terms.pop
    return nil if t
  end
  s.lstrip[1..-2]
#
end
#methods permutates all values for operators and variables, when tries to build valid string
def solve_for_operators_with_conditional(problem)
  p "in solver function"
  c =0

  #we select how many binary operators in array + 1


  m = problem.size - 1 
  (problem.operators + ['x', '0', '1']).repeated_permutation(m).each do |perm|
    next if (perm & problem.operators).size != problem.operators.size
    next if 1 + perm.count{|x| BINARIES.include? x} + 2*perm.count{|x| x == "if0" }  != perm.count{|x| !((BINARIES + UNARIES + ["if0"]).include?(x)) }
    s = build_string(perm)
    if s
      c = c + 1
      exp = "(lambda (x) #{s})" if s # resulting formula. now correctly works for binary and unary operators
      yield exp if block_given? if s #optionally sends result to a block
    end 
  end   
  p "solver function ends. total number of permutations: #{c}"
end