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
   
   def save
     if self.id 
       self.update
     else 
      sql = <<-SQL
        INSERT INTO dogs (name, breed) 
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.breed)
      
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs;")[0][0]
      self
    end 
   end 
   
   def update
      sql_update = <<-SQL
         UPDATE dogs SET name = ?, breed = ? WHERE id = ?;
      SQL

      DB[:conn].execute(sql_update, self.name, self.breed, self.id)
   end
   
   def self.create(hash)
     new_dog = Dog.new(hash)
     new_dog.save
   end 
   
   def self
end 