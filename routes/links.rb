require 'sinatra'
require 'json'
require_relative '../models/link'


get '/' do
  @links = Link.order(Sequel.desc(:hits)).all
  erb :index
end

get '/links' do
  redirect '/'
end


post '/links' do
  authenticate!
  begin
    link = Link.create(
      name: params[:name],
      url: params[:url],
      category: params[:category],
      tags: params[:tags]
    )
    log_audit('create', 'Link', link.id, "Created link #{link.name}")
    redirect '/'
  rescue Sequel::ValidationFailed, Sequel::DatabaseError => e
    halt "Error: #{e.message}"
  end
end

get '/links/suggest' do
  query = params[:q]
  escaped = Sequel.escape_like(query.to_s)
  results = Link.where(Sequel.like(:name, "#{escaped}%")).or(Sequel.like(:url, "%#{escaped}%"))
  results = results.all.map(&:name)
  content_type :json
  [query, results].to_json
end

get '/links/search' do
  query = params[:q]
  link  = Link[name: query]
  if link
    redirect "/#{link.name}"
  else
    @links = Link.where(Sequel.like(:name, "#{Sequel.escape_like(query.to_s)}%"))
    erb :index
  end
end

get '/links/opensearch.xml' do
  content_type :xml
  erb :opensearch, layout: false
end


get '/links/:id/remove' do
  authenticate!
  halt 403 unless admin?
  link = Link.find(id: params[:id])
  halt 404 unless link
  log_audit('delete', 'Link', link.id, "Deleted link #{link.name}")
  link.destroy
  redirect '/'
end

get '/:name/?*?' do
  link = Link[name: params[:name]]
  halt 404 unless link
  link.hit!
  parts = (params[:splat].first || '').split('/')
  url = link.url
  url %= parts if parts.any?
  redirect url
end
