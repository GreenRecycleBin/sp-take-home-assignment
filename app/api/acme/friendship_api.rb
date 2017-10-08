require 'size'
require 'valid_email'
require 'valid_emails'

module Acme
  class FriendshipAPI < Grape::API
    helpers do
      params :friends do
        requires :friends, type: Array[String], size: 2, valid_emails: true, fail_fast: true, desc: 'Two email addresses'
      end
    end

    resource :friendship do
      params do
        use :friends
      end

      desc 'Create a friendship' do
        detail 'Friendship is mutual.'
        http_codes [[201, {success: true}.to_json], [400, {error: 'A sample error message.'}.to_json]]
      end

      post do
        user_email = params[:friends].first
        friend_email = params[:friends].last

        Friendship.add(user_email: user_email, friend_email: friend_email)

        {success: true}
      end

      params do
        requires :email, type: String, valid_email: true, fail_fast: true, desc: 'An email address'
      end

      desc 'Get all friends' do
        detail 'Friendship is mutual.'
        http_codes [[200, {success: true, friends: %w(a@example.com), count: 1}.to_json],
                    [400, {error: 'A sample error message.'}.to_json]]
      end

      get do
        friends = Friendship.for(email: params[:email]).map(&:friend)

        {success: true, friends: friends.map(&:email), count: friends.size}
      end

      namespace :common do
        params do
          use :friends
        end

        desc 'Get all common friends' do
          http_codes [[200, {success: true, friends: %w(a@example.com b@example.com), count: 1}.to_json],
                      [400, {error: 'A sample error message.'}.to_json]]
        end

        get do
          user_email = params[:friends].first
          friend_email = params[:friends].last

          common_friends = Friendship.common(user_email: user_email, friend_email: friend_email)

          {success: true, friends: common_friends.map(&:email), count: common_friends.size}
        end
      end
    end
  end
end
