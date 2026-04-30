require 'sinatra'
require_relative '../models/link'


get '/dashboard' do
  authenticate!
  @total_links = Link.count
  @total_hits = Link.sum(:hits)
  @top_links = Link.order(Sequel.desc(:hits)).limit(10)
  @recent_links = Link.order(Sequel.desc(:created_at)).limit(10)
  @search_query = params[:q]
  @filtered_links = if @search_query && !@search_query.empty?
    Link.where(Sequel.like(:name, "%#{@search_query}%")).or(Sequel.like(:url, "%#{@search_query}%")).all
  else
    []
  end
  @audit_logs = AuditLog.order(Sequel.desc(:created_at)).limit(20)
  erb :dashboard
end
