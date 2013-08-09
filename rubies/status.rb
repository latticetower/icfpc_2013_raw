require 'rubygems'
require 'json'

require 'rubygems'
require 'json'


#interface Status {
#     easyChairId: number;
#     contestScore: number;
#     lightningScore: number;
#     trainingScore: number;
#     mismatches: number;
#     numRequests: number;
#     requestWindow: {
#       resetsIn: number;
#       amount: number;
#       limit: number
#     };
#     cpuWindow: {
#       resetsIn: number;
#       amount: number;
#       limit: number
#     };
#    cpuTotalTime:number;
#  }
class Status
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