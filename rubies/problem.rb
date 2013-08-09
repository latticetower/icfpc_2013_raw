require 'rubygems'
require 'json'




#interface Problem {
#    id: string;
#    size: number;
#    operators: string[];
#    solved?: boolean;
#    timeLeft?: number
#  }
class Problem 
  attr_reader  :id, :size, :operators, :solved, :time_left
  def initialize(id, size, operators, solved, time_left)
    @id = id
    @size = size
    @operators = operators
    @solved = solved
    @time_left = time_left
  end
  def to_json
    {'id' => @id, 'size' => @size, 'operators' => @operators, 
      'solved' => @solved, 'timeLeft' => @time_left}.to_json
  end
  
  def self.from_json string
        data = JSON.load string
        self.new data['id'], data['size'], data['operators'], data['solved'], data['timeLeft']
    end
end