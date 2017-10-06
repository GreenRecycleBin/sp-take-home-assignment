class MyAPI < Grape::API
  prefix 'api'
  format :json

  mount Acme::FriendshipAPI
end
