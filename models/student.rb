class Student
  attr_reader :id, :squad_id
  attr_accessor :name, :age, :spirit

  def initialize params, existing=false
    @id = params["id"]
    @squad_id = params["squad_id"]
    @name = params["name"]
    @age = params["age"]
    @spirit = params["spirit"]
  end

  def existing?
    @existing
  end

  def self.conn= connection
    @conn = connection
  end

  def self.conn
    @conn
  end

  # should return a list of students
  def self.all
    @conn.exec("SELECT * FROM students")
  end

  # should return a squad by id
  # or nil if not found
  def self.find id
    new @conn.exec('SELECT * FROM students WHERE id = ($1)', [ id ] )[0], true
  end

def save
  if existing?
    Student.conn.exec('UPDATE students SET name=$1, squad_id=$2, age=$3, spirit_animal=$4 WHERE id = $5', [ @name, @squad_id, @age, @spirit, @id ] )
  else
    Student.conn.exec('INSERT INTO students (name, squad_id, age, spirit_animal) values ($1, $2, $3, $4)', [ @name, @squad_id, @age, @spirit ] )
  end
end

def self.create params
  new(params).save
end

def destroy
  Student.conn.exec('DELETE FROM students WHERE squad_id = $1', [ id ] )
end

end
