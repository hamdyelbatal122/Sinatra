require_relative 'spec_helper'

RSpec.describe 'Sinatra app' do
  def create_user(username:, password:, role:)
    user = User.new(username: username, role: role)
    user.password = password
    user.save
    user
  end

  it 'loads homepage' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Go URL Shortener')
  end

  it 'requires login for settings page' do
    get '/settings'
    expect(last_response.status).to eq(302)
    expect(last_response.location).to include('/login')
  end

  it 'allows authenticated user to change password' do
    user = create_user(username: 'reader1', password: 'password123', role: 'reader')
    post '/login', username: user.username, password: 'password123'

    post '/settings/password',
         current_password: 'password123',
         new_password: 'newpassword123',
         confirm_password: 'newpassword123'

    expect(last_response).to be_ok
    expect(last_response.body).to include('Password updated successfully')
  end

  it 'blocks reader from creating links' do
    user = create_user(username: 'reader2', password: 'password123', role: 'reader')
    post '/login', username: user.username, password: 'password123'
    post '/links', name: 'x', url: 'https://example.com'

    expect(last_response.status).to eq(403)
  end

  it 'supports advanced search by category and tag' do
    Link.create(name: 'docs', url: 'https://docs.example.com', category: 'dev', tags: 'ruby,sinatra')
    Link.create(name: 'news', url: 'https://news.example.com', category: 'media', tags: 'tech')

    get '/links/search', category: 'dev', tag: 'ruby'
    expect(last_response).to be_ok
    expect(last_response.body).to include('docs')
    expect(last_response.body).not_to include('news')
  end
end
