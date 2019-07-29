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
    
    def self.all
        @@all
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
   
   def self.new_from_db(row)
     id = row[0]
     name = row[1]
     breed = row[2]
     new_dog = self.create(id: id, name: name, breed: breed)
   end 
   
   def self.find_by_id(id)
     sql = "SELECT * FROM dogs WHERE id = ?"
      found = DB[:conn].execute(sql, id)[0]
      if !found.empty? 
         self.new_from_db(found)
      end
   end 
   
   def self.find_or_create_by(name:, breed:)
      dog = DB[:conn].execute("SELECT * from dogs WHERE name = ? AND breed = ?", name, breed)
      if !dog.empty? 
         found_id, found_name, found_breed = dog[0]
         doggy_hash = {:id => found_id, :name => found_name, :breed => found_breed}
         dog = Dog.new(doggy_hash)
      else
         dog = self.create(name: name, breed: breed)
      end
   end
end 