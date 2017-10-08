require 'set'

module Acme
  class UpdateAPI < Grape::API
    helpers do
      params :requestor_and_target do
        requires :requestor, type: String, valid_email: true, fail_fast: true, desc: 'An email address'
        requires :target, type: String, valid_email: true, fail_fast: true, desc: 'An email address'
      end
    end

    resource :update do
      params do
        use :requestor_and_target
      end

      desc 'Subscribe to updates' do
        http_codes [[201, {success: true}.to_json], [400, {error: 'A sample error message.'}.to_json]]
      end

      post do
        Subscription.add(requestor_email: params[:requestor], target_email: params[:target])

        {success: true}
      end

      params do
        requires :sender, type: String, valid_email: true, fail_fast: true, desc: 'An email address'
        requires :text, type: String, fail_fast: true, desc: 'A message that may contain some email addresses'
      end

      desc 'Get all recipients' do
        http_codes [[200, {success: true, recipients: %w(a@example.com b@example.com)}.to_json], [400, {error: 'A sample error message.'}.to_json]]
      end

      get do
        sender = User.find_by(email: params[:sender])
        recipients = Friendship.for(email: params[:sender]).map(&:friend)

        if sender
          recipients += sender.followers
        end

        mentioned_emails = params[:text].scan(Validator::RELAXED_EMAIL_REGEXP)
        recipient_emails = Set.new(recipients.map(&:email) + mentioned_emails)

        if sender
          recipient_emails -= sender.block_users.map(&:email)
        end

        {success: true, recipients: recipient_emails}
      end

      namespace :block do
        params do
          use :requestor_and_target
        end

        desc 'Block updates' do
          http_codes [[201, {success: true}.to_json], [400, {error: 'A sample error message.'}.to_json]]
        end

        post do
          requestor = User.find_or_create_by(email: params[:requestor])
          target = User.find_or_create_by(email: params[:target])

          if requestor != target
            requestor.blocks.find_or_create_by(target: target)
          end

          {success: true}
        end
      end
    end
  end
end
