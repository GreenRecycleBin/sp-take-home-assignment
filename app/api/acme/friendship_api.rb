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
        {success: true}
      end

      params do
        requires :email, type: String, valid_email: true, fail_fast: true
      end

      get {}
    end
  end
end
