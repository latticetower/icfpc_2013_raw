require 'rubygems'
require 'json'

require 'rubygems'
require 'json'

class TrainingProblem 
  attr_reader :challenge, :id, :size, :operators
  def initialize(challenge, id, size, operators)
    @challenge = challenge
    @id = id
    @size = size
    @operators = operators
  end
  def to_json
    {'challenge'=> @challenge, 'id' => @id, 'size' => @size, 'operators' => @operators}.to_json
  end
  
  def self.from_json string
        data = JSON.load string
        self.new data['challenge'], data['id'], data['size'], data['operators']
    end
end