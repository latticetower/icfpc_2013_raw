require 'rubygems'
require 'json'

require 'rubygems'
require 'json'


#  interface GuessResponse {
#     status: string;
#     values?: string[];
#    message?: string;
#   }
class GuessResponse 
  attr_reader  :status, :values, :message
  def initialize(status, values, message)
    @status = status
    @values = values
    @message = message
  end
  def to_json
    {'status' => @status, 'values' => @values, 'message' => @message}.to_json
  end
  
  def self.from_json string
        data = JSON.load string
        self.new data['status'], data['values'], data['message']
  end
end