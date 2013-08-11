require 'net/http'
require 'rubygems'
require 'json'

require "./problem"
require "./noisy_listener"
require "./eval_request"
require "./eval_response"

UNARIES = ["not", "shl1", "shr1", "shr4", "shr16"]
BINARIES = ["and", "or", "xor", "plus"]


module BinaryMethods
  def and_method(x, y)
    (x & y).modulo(0x10000000000000000)
  end
  def or_method x, y
    (x | y).modulo(0x10000000000000000)
  end
  def xor_method x, y
    (x ^ y).modulo(0x10000000000000000)
  end
  def plus_method x, y
    (x + y).modulo(0x10000000000000000)
  end
end

module UnaryMethods
  def not_method x
    (~x).modulo(0x10000000000000000)
  end
  def shl1_method x
    (x << 1).modulo(0x10000000000000000)
  end
  def shr1_method x
    (x >> 1).modulo(0x10000000000000000)
  end
  def shr4_method x
    (x >> 4).modulo(0x10000000000000000)
  end
  def shr16_method x
    (x >> 16).modulo(0x10000000000000000)
  end
end
module ComplexMethods
  def if0_method x, y, z
    if (x).modulo(0x10000000000000000)
      (y).modulo(0x10000000000000000) 
    else 
      (z).modulo(0x10000000000000000)
    end
  end
end

class BasicEvaluator
  include BinaryMethods
  include UnaryMethods
  include ComplexMethods
  attr_reader :formula, :process_text

  def initialize(formula)
    @formula = formula
  end

  def calculate(vector)
    if @process.nil?
      cde = processed_form
      instance_eval "@process_text='{#{cde}}'"
      instance_eval  "@process = #{cde}"
      return @process.call(vector)
    else
      return @process.call(vector)
    end
    nil
  end


  def valid?
     #vars = @formula.scan(/^\(\s*lambda\s*\(([a-z][a-z_0-9]*)\).*\)$/).flatten[0] 
    ff = formula.scan(/^\(\s*lambda\s*\([a-z][a-z_0-9]*\)\s*(.*)\)$/).flatten[0]

    check_formula2(ff)
  end

def check_formula2(formula)
  braces_counter = 0
  first_term = false
  str_buf = ""
  formula.size.times do |i|
    if formula[i] == '('
      first_term = true
      str_buf = ""
      braces_counter = braces_counter + 1
    end
    if formula[i] == ')'
      braces_counter = braces_counter - 1
      return false if braces_counter < 0
    end
    if "abcdefghijklmnopqrstuvwxyz_0123456789".index(formula[i])
      if first_term
        str_buf = str_buf + formula[i]
      end
    end
    if formula[i] == ' '
      if first_term
        return false if not (BINARIES + UNARIES + ["if0"]).include? str_buf
        str_buf = ""
        first_term = false
      end
    end
  end
  return braces_counter == 0 && !first_term
end

  def method_missing(method_name, *args)
    if method_name == :ss
      vars = @formula.scan(/^\(\s*lambda\s*\(([a-z][a-z_0-9]*)\).*\)$/).flatten[0] 
      method = @formula.scan(/^\(\s*lambda\s*\([a-z][a-z_0-9]*\)(.*)\)$/).flatten[0]
      return method.call(vars)
    end
  end


  def processed_form
    vars = @formula.scan(/^\(\s*lambda\s*\(([a-z][a-z_0-9]*)\).*\)$/).flatten[0] 
    ff = formula.scan(/\(\s*lambda\s*\([a-z][a-z_0-9]*\)\s*\((.*)\)\s*\)/).flatten[0]
    subst_string2 = /(?<f0>(and|or|xor|plus))\s+(?<f1>(\((?:(?>\\[()]|[^()])|\g<f1>)*\)|(?:[^\(\)\s]+))[^\(\)\s+]*)\s*(?<f2>(\((?:(?>\\[()]|[^()])|\g<f2>)*\)|(?:[^\(\)\s]+))[^\(\)\s+]*)/
    subst_string1 = /(?<f0>(not|shr1|shl1|shr4|shr16))\s+(?<f1>(\((?:(?>\\[()]|[^()])|\g<f1>)*\)|(?:[^\(\)\s]+))[^\(\)\s+]*)/
    subst_string3 = /(?<f0>(if0))\s+(?<f1>(\((?:(?>\\[()]|[^()])|\g<f1>)*\)|(?:[^\(\)\s]+))[^\(\)\s+]*)\s*(?<f2>(\((?:(?>\\[()]|[^()])|\g<f2>)*\)|(?:[^\(\)\s]+))[^\(\)\s+]*)\s*(?<f3>(\((?:(?>\\[()]|[^()])|\g<f3>)*\)|(?:[^\(\)\s]+))[^\(\)\s+]*)/
    
    UNARIES.each do |op1|
      ff = ff.gsub(subst_string1, '\k<f0>_method \k<f1>')
    end
    BINARIES.each do |op2|
      ff = ff.gsub(subst_string2, '\k<f0>_method \k<f1>, \k<f2>')
    end
    ff = ff.gsub(subst_string3, '\k<f0>_method \k<f1>, \k<f2>, \k<f3>')
    "lambda{|#{vars}| #{ff}}"
  end
end

#bb = BasicEvaluator.new("(lambda(x)(and (if0 x 1 0) (or (and x 1) 0)))")
#p bb.valid?
