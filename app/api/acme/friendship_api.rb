module Acme
  class FriendshipAPI < Grape::API
    resource :friendship do
      params do
        requires :friends, type: Array[String]
      end

      post do
        {success: true}
      end
    end
  end
end
