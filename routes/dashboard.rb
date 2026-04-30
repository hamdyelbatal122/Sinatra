require 'sinatra'
require_relative '../models/link'


get '/dashboard' do
  authenticate!
  halt 403 unless can_manage_links?
  @total_links = Link.count
  @total_hits = Link.sum(:hits)
  @top_links = Link.order(Sequel.desc(:hits)).limit(10)
  @recent_links = Link.order(Sequel.desc(:created_at)).limit(10)
  @search_query = params[:q]
  @category_query = params[:category]
  @tag_query = params[:tag]
  @filtered_links = if @search_query && !@search_query.empty?
    Link.where(Sequel.like(:name, "%#{@search_query}%")).or(Sequel.like(:url, "%#{@search_query}%")).all
  else
    Link.dataset
        .yield_self { |ds| @category_query.to_s.empty? ? ds : ds.where(Sequel.like(:category, "%#{@category_query}%")) }
        .yield_self { |ds| @tag_query.to_s.empty? ? ds : ds.where(Sequel.like(:tags, "%#{@tag_query}%")) }
        .all
  end
  @audit_logs = AuditLog.order(Sequel.desc(:created_at)).limit(20)
  erb :dashboard
end
