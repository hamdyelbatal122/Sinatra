require 'sinatra'
require 'json'
require_relative '../models/link'

before '/api/*' do
  content_type :json
end

# Create a new short link (admin only)
post '/api/links' do
  authenticate!
  halt 403 unless admin?
  data = JSON.parse(request.body.read)
  link = Link.create(name: data['name'], url: data['url'])
  { id: link.id, name: link.name, url: link.url, hits: link.hits }.to_json
end

# List all links
get '/api/links' do
  links = Link.order(Sequel.desc(:hits)).all.map { |l| { id: l.id, name: l.name, url: l.url, hits: l.hits } }
  links.to_json
end

# Get a single link
get '/api/links/:id' do
  link = Link[params[:id]]
  halt 404 unless link
  { id: link.id, name: link.name, url: link.url, hits: link.hits }.to_json
end

# Delete a link (admin only)
delete '/api/links/:id' do
  authenticate!
  halt 403 unless admin?
  link = Link[params[:id]]
  halt 404 unless link
  link.destroy
  { status: 'deleted' }.to_json
end
