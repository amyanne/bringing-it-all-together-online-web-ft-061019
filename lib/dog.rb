require 'pry'
class Dog 
  attr_accessor :name, :breed, :id 
  
  @@all = []
  
  def initialize(hash, id = nil)
    @name = hash[:name]
    @breed = hash[:breed]
    @id = id
    end 
  def self.create_table 
    sql_create_table = <<-SQL
         CREATE TABLE IF NOT EXISTS dogs (
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
         );
      SQL
      
      DB[:conn].execute(sql_create_table)
    end 
    
    def self.drop_table
      sql_drop = "DROP TABLE IF EXISTS dogs;"
      DB[:conn].execute(sql_drop)
   end
end 