require 'size'
require 'valid_email'
require 'valid_emails'

module Acme
  class FriendshipAPI < Grape::API
    resource :friendship do
      params do
        requires :friends, type: Array[String], size: 2, valid_emails: true, fail_fast: true
      end

      post do
        user_email = params[:friends].first
        friend_email = params[:friends].last

        user = User.find_or_create_by(email: user_email)
        friend = User.find_or_create_by(email: friend_email)

        if user != friend
          user.friendships.find_or_create_by(friend: friend)
          friend.friendships.find_or_create_by(friend: user)
        end

        {success: true}
      end

      params do
        requires :email, type: String, valid_email: true, fail_fast: true
      end

      get do
        user = User.find_by(email: params[:email])

        friends = if user
                    user.friendships.map(&:friend)
                  else
                    Friendship.none
                  end

        {success: true, friends: friends.map(&:email), count: friends.size}
      end
    end
  end
end
