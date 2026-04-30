require_relative '../models/user'
require 'bcrypt'

if User.count == 0
  admin = User.new(username: 'admin', role: 'admin')
  admin.password = 'admin123'
  admin.save
  puts 'Admin user created: admin / admin123'
end
