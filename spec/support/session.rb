def login(user = create_member)
  visit login_path
  fill_in 'Login', with:user.userid
  fill_in 'Password', with:'secret'
  click_button 'Login'
  user
end
