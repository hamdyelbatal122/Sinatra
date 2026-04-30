# Helper to seed admin user if not exists
require_relative '../models/user'
require 'bcrypt'

def seed_admin
  if User.count == 0
    admin = User.new(username: 'admin', role: 'admin')
    admin.password = 'admin123'
    admin.save
  end
end
