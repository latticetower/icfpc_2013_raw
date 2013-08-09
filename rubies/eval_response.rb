require 'rubygems'
require 'json'

#  interface EvalResponse {
#     status: string; 
#     outputs?: string[];  
#     message?: string;    
#   }
class EvalRequest 
  attr_reader :status, :outputs, :message
  def initialize(status,outputs, message)
    @status = status
    @outputs = outputs
    @message = message
  end
  def to_json
    {'status' => @status, 'outputs' => @outputs, 'message' => @message}.to_json
  end
  
  def self.from_json string
        data = JSON.load string
        self.new data['status'], data['outputs'], data['message']
    end
end