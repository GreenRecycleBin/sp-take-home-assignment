require 'size'
require 'valid_email'
require 'valid_emails'

module Acme
  class FriendshipAPI < Grape::API
    helpers do
      params :friends do
        requires :friends, type: Array[String], size: 2, valid_emails: true, fail_fast: true
      end
    end

    resource :friendship do
      params do
        use :friends
      end

      post do
        user_email = params[:friends].first
        friend_email = params[:friends].last

        Friendship.add(user_email: user_email, friend_email: friend_email)

        {success: true}
      end

      params do
        requires :email, type: String, valid_email: true, fail_fast: true
      end

      get do
        friends = Friendship.for(email: params[:email]).map(&:friend)

        {success: true, friends: friends.map(&:email), count: friends.size}
      end

      namespace :common do
        params do
          use :friends
        end

        get {}
      end
    end
  end
end
