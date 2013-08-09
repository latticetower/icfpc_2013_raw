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
  
  def self.from_json str
    obj_data = JSON.load str
    self.new(obj_data['id'], obj_data['size'], obj_data['operators'], obj_data['solved'], obj_data['timeLeft'])
  end
  def self.array_from_json(str, size = nil)
    obj_data = JSON.load str
    arr = Array.new 
    obj_data.each do |obj|
      arr << self.new(obj['id'], 
        obj['size'], 
        obj['operators'], obj['solved'], 
        obj['timeLeft']) if obj['size'] == size || size.nil?
    end
    arr
  end
end