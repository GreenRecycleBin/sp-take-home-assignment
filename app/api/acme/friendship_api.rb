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

        get do
          user_email = params[:friends].first
          friend_email = params[:friends].last

          user = User.find_by(email: user_email)
          friend = User.find_by(email: friend_email)

          column_name = 'common_friend_id'

          query = <<~SQL
          SELECT friendships1.friend_id AS #{column_name}
          FROM (
            SELECT *
            FROM friendships
            WHERE user_id = $1
          ) friendships1 INNER JOIN (
            SELECT *
            FROM friendships
            WHERE user_id = $2
          ) friendships2
            ON friendships1.friend_id = friendships2.friend_id
          SQL

          common_friend_ids =
            if user && friend
              result = ActiveRecord::Base.connection.raw_connection.execute(query, [user.id, friend.id])
              result.map { |row| row[column_name] }
            else
              []
            end

          common_friends = User.where(id: common_friend_ids)

          {success: true, friends: common_friends.map(&:email), count: common_friends.size}
        end
      end
    end
  end
end
