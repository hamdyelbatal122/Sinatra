helpers do
  def t(key)
    translations = {
      'login' => 'Login',
      'logout' => 'Logout',
      'short_name' => 'Short name',
      'destination_url' => 'Destination URL',
      'create' => 'Create',
      'remove' => 'Remove',
      'hits' => 'Hits',
      'no_links' => 'No links found.',
      'go_url_shortener' => 'Go URL Shortener',
      'logged_in_as' => 'Logged in as',
      'invalid_credentials' => 'Invalid username or password.'
    }
    translations[key] || key
  end
end
