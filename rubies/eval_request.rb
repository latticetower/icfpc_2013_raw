require 'rubygems'
require 'json'

# interface EvalRequest {
#    id?: string;
#    program?: string;
#    arguments: string[];
#   }
class EvalRequest 
  attr_reader :id, :program, :arguments
  def initialize(id, program, arguments)
    @id = id
    @program = program
    @arguments = arguments
  end
  def to_json
    {'id' => @id, 'program' => @program, 'arguments' => @arguments}.to_json
  end
  
  def self.from_json string
        data = JSON.load string
        self.new data['id'], data['program'], data['arguments']
    end
end