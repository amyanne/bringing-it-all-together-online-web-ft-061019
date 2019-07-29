require 'pry'
class Dog 
  attr_accessor :name, :breed, :id 
  
  @@all = []
  
  def initialize(hash, id = nil)
    self.name = hash[name]
    self.name = hash[breed]
    @id = hash[id]
    binding.pry
  end 
end 