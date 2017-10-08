class MyAPI < Grape::API
  prefix 'api'
  format :json

  mount Acme::FriendshipAPI
  mount Acme::UpdateAPI

  add_swagger_documentation
end
