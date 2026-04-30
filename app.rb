require 'sinatra'
require 'sequel' 
require 'sinatra/sequel'
require 'json'

# Models & migrations

migration 'create links' do
  database.create_table :links do
    primary_key :id
    String :name, :unique => true, :null => false
    String :url, :unique => false, :null => false
    Integer :hits, :default => 0
    DateTime :created_at
    index :name

  end
end

class Link < Sequel::Model
  def hit!
    self.hits += 1
  end
end


configure do
  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { 'supersecret' }
  set :erb, :escape_html => true
end

# Actions
get '/' do
  @links = Link.order(Sequel.desc(:hits)).all
    require 'sinatra'
    require 'sinatra/sequel'
    require 'json'

    # Load models, helpers, and routes
    Dir[File.join(__dir__, 'models', '*.rb')].each { |file| require file }
    Dir[File.join(__dir__, 'helpers', '*.rb')].each { |file| require file }
    Dir[File.join(__dir__, 'routes', '*.rb')].each { |file| require file }

    configure do
      set :erb, :escape_html => true
    end
  </OpenSearchDescription>

              
            
