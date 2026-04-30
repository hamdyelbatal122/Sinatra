require 'sinatra'
require 'sinatra/sequel'
require 'json'
require 'bcrypt'

Dir[File.join(__dir__, 'models', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'helpers', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'routes', '*.rb')].sort.each { |file| require file }

configure do
  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { 'supersecret' }
  set :erb, escape_html: true
end
