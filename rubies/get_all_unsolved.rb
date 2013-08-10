require 'net/http'
require 'rubygems'
require 'json'

require "./problem"
require "./noisy_listener"

UNARIES = ["not", "shl1", "shr1", "shr4", "shr16"]
BINARIES = ["and", "or", "xor", "plus"]
#h = Net::HTTP.new('icfpc2013.cloudapp.net')
#resp = h.post('/myproblems?auth=00306ooBUr4BvTjTrWJJyZfHXbwBVU2kLk1cipuAvpsH1H', nil)

f = File.open('metadata.txt') 
arr = f.gets #resp.body 
@arr = Problem.array_from_json(arr, 6)

p @arr.size
@solved = 0
@time_exceeded = 0
@arr.each do |problem|
  @solved = @solved + 1 if problem.solved
  @time_exceeded = @time_exceeded + 1 if problem.time_left == 0
  unless problem.solved  || problem.time_left
   # p "solving #{problem.id}"
   # p "operators: #{problem.operators} #{problem.time_left} #{problem.size}"
    if problem.operators.size == 1 && problem.size == 4
      ['x', '1', '0'].repeated_permutation(2) do |perm|
        exp = "(lambda (x) (#{problem.operators[0]} #{perm.join(' ')}))"
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
    if problem.operators.size == 2 && problem.size == 5
      @op1 = problem.operators[1]
      @op2 = problem.operators[0]
      if UNARIES.include?(problem.operators[0]) 
        @op1 = problem.operators[0]
        @op2 = problem.operators[1]
      end
      ['x', '1', '0'].repeated_permutation(2) do |perm|
        exp2 = "(lambda (x) (#{@op2} #{perm.join(' ('+ @op1.to_s + ' ')})))"
        exp = "(lambda (x) (#{@op1} (#{@op2} #{perm.join(' ')})))"
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

    #
    if problem.operators.size == 2 && problem.size == 6
      p "solving #{problem.id}"
    p "operators: #{problem.operators} #{problem.time_left} #{problem.size}"
      @op1 = []
      @op2 = []
      @op1 << problem.operators[0] if UNARIES.include?(problem.operators[0]) 
      @op1 << problem.operators[1] if UNARIES.include?(problem.operators[1]) 
      @op2 << problem.operators[0] if BINARIES.include?(problem.operators[0]) 
      @op2 << problem.operators[1] if BINARIES.include?(problem.operators[1]) 
      p "#{@op1.size} #{@op2.size}"
 go_away = false
      if @op1.size == 0
        ['x', '1', '0'].repeated_permutation(3) do |perm|
          break if go_away
           ["(lambda (x) (#{@op2[0]} (#{@op2[1]} #{perm[0]} #{perm[1]}) #{perm[2]}))",
          "(lambda (x) (#{@op2[1]} (#{@op2[0]} #{perm[0]} #{perm[1]}) #{perm[2]}))"].each do |exp|
           
            result = basic_guess(problem.id, exp)
            if result!="200"
              puts 'ERROR ERROR'
              puts problem.id
              go_away = true
              break
            end
            sleep(3)
          end#end each

          end#end perm
        end #end if
             
                   #opsize >0
          if @op1.size ==1
            ['x', '1', '0'].repeated_permutation(2) do |perm|
              [ "(lambda (x) (#{@op2[0]} (#{@op1[0]} (#{@op1[0]} #{perm[0]})) #{perm[1]}))",
               "(lambda (x) (#{@op2[0]} (#{@op1[0]} #{perm[0]}) (#{@op1[0]} #{perm[1]})))",
               "(lambda (x) (#{@op1[0]} (#{@op2[0]} #{perm[0]} (#{@op1[0]} #{perm[1]}))))",
               "(lambda (x) (#{@op1[0]} (#{@op1[0]} (#{@op2[0]} #{perm[0]} #{perm[1]}))))"].each do |exp|
                p exp
                #result = basic_guess(problem.id, exp)
            #if result!="200"
            #  puts 'ERROR ERROR'
            #  puts problem.id
            #  
            #  break
            #end
            #sleep(3)
               end#each
            end #perm
              end  #if
            #end opsize
      end   #if problem.operators.size == 2 && problem.size == 6
  
##another
if  problem.size == 6 && problem.operators.size ==3
      p "solving #{problem.id}"
    p "operators: #{problem.operators} #{problem.time_left} #{problem.size} #{problem.solved} #{problem.time_left}"
    end
    

    #
  end

end
p "solved: #{@solved} timeout: #{@time_exceeded}"