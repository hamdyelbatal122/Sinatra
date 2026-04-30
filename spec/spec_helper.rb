ENV['RACK_ENV'] = 'test'
ENV['DATABASE_URL'] = 'sqlite://db/test.sqlite3'
ENV['SESSION_SECRET'] = 'test-secret'

require 'rack/test'
require 'rspec'
require 'fileutils'

FileUtils.mkdir_p('db')

require_relative '../app'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:suite) do
    DB.drop_table?(:audit_logs)
    DB.drop_table?(:links)
    DB.drop_table?(:users)

    DB.create_table :users do
      primary_key :id
      String :username, unique: true, null: false
      String :password_hash, null: false
      String :role, default: 'reader', null: false
      DateTime :created_at
    end

    DB.create_table :links do
      primary_key :id
      String :name, unique: true, null: false
      String :url, null: false
      String :category
      String :tags
      Integer :hits, default: 0
      DateTime :created_at
    end

    DB.create_table :audit_logs do
      primary_key :id
      String :action, null: false
      String :entity_type, null: false
      Integer :entity_id, null: false
      Integer :user_id
      String :details
      DateTime :created_at
    end
  end

  config.before do
    Link.dataset.delete
    User.dataset.delete
    AuditLog.dataset.delete
  end
end

def app
  Sinatra::Application
end
