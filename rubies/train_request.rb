require 'rubygems'
require 'json'

class TrainRequest 
  attr_reader :size, :operators
  def initialize(size, operators)
    @size = size
    @operators = operators
  end
  def to_json
    {'size' => @size, 'operators' => @operators}.to_json
  end
  
  def self.from_json string
        data = JSON.load string
        self.new data['size'], data['operators']
    end
end