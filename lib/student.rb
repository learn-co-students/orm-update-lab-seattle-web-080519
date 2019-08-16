require_relative "../config/environment.rb"
require 'pry'
class Student
 
  attr_accessor :id, :name, :grade
    def initialize name, grade, id = nil
      @name = name
      @grade = grade
      @id = id
    end
    def self.create_table
      DB[:conn].execute("create table students (id integer primary key, name text, grade integer)")
    end
    def self.drop_table
      DB[:conn].execute("drop table students")
    end
    def save
      if id
        update
      else
      DB[:conn].execute("insert into students (name, grade) values (?,?)", self.name, self.grade)
      sql = "select * from students order by id desc limit 1"
      n = DB[:conn].execute(sql).flatten
      self.id = n[0]
      end
    end
    def self.find_by_name name 
      sql = "select * from students where name = ?"
      n = DB[:conn].execute(sql,name).flatten
      new_from_db(n)
    end
    def self.create name,grade
      Student.new(name,grade).save
    end
    def self.new_from_db data
      Student.new(data[1],data[2],data[0])
    end
    def update
      sql = "update students set name = ?, grade = ? where id = ?"
      DB[:conn].execute(sql,name,grade,id)
    end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
