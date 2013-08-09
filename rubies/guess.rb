require 'rubygems'
require 'json'

require 'rubygems'
require 'json'


# interface Guess {
#    id: string;
#    program: string;
#   }
class Guess 
  attr_reader  :id, :program
  def initialize(id, program)
    @id = id
    @program = program
  end
  def to_json
    {'id' => @id, 'program' => @program}.to_json
  end
  
  def self.from_json string
        data = JSON.load string
        self.new data['id'], data['program']
  end
end