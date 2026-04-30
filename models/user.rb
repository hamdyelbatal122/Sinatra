require 'sequel'

migration 'create users' do
  database.create_table? :users do
    primary_key :id
    String :username, unique: true, null: false
    String :password_hash, null: false
    String :role, default: 'user', null: false
    DateTime :created_at
    index :username
  end
end

class User < Sequel::Model
  def password=(password)
    self.password_hash = BCrypt::Password.create(password)
  end

  def authenticate(password)
    BCrypt::Password.new(self.password_hash) == password
  end
end
