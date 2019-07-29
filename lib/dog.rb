require 'pry'
class Dog 
  attr_accessor :name, :breed, :id 
  
  @@all = []
  
  def initialize(hash, id = nil)
    @name = hash[:name]
    @breed = hash[:breed]
    @id = id
    end 
  def self.create
end 