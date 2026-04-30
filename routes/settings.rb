require 'sinatra'

get '/settings' do
  authenticate!
  erb :settings
end

post '/settings/password' do
  authenticate!

  current_password = params[:current_password].to_s
  new_password = params[:new_password].to_s
  confirm_password = params[:confirm_password].to_s

  unless current_user.authenticate(current_password)
    @error = 'Current password is incorrect.'
    return erb :settings
  end

  if new_password.length < 8
    @error = 'New password must be at least 8 characters.'
    return erb :settings
  end

  unless new_password == confirm_password
    @error = 'Password confirmation does not match.'
    return erb :settings
  end

  current_user.password = new_password
  current_user.save
  log_audit('update_password', 'User', current_user.id, 'User changed account password')
  @success = 'Password updated successfully.'
  erb :settings
end
