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
  def initialize(id, size, operators, solved = false, time_left = nil)
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

  def self.array_from_json(str, size = nil, ops = nil)
    obj_data = JSON.load str
    arr = Array.new 
    obj_data.each do |obj|
       arr << self.new(obj['id'], obj['size'], obj['operators'], obj['solved'], 
        obj['timeLeft'])  if ops.nil? && (obj['size'] == size || size.nil?) # && (obj['solved'].nil? || !obj['solved'])
      if  (obj['size'] == size && (ops & obj['operators'] == obj['operators']))
      arr << self.new(obj['id'], obj['size'], obj['operators'], obj['solved'], 
        obj['timeLeft']) 
      else
        arr << self.new(obj['id'], obj['size'], obj['operators'], obj['solved'], 
        obj['timeLeft'])  if (size.nil? && (ops & obj['operators'] == obj['operators']))
      end
    end
    arr
  end
end