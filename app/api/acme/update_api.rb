module Acme
  class UpdateAPI < Grape::API
    helpers do
      params :requestor_and_target do
        requires :requestor, type: String, valid_email: true, fail_fast: true
        requires :target, type: String, valid_email: true, fail_fast: true
      end
    end

    resource :update do
      params do
        use :requestor_and_target
      end

      post do
        {success: true}
      end

      namespace :block do
        params do
          use :requestor_and_target
        end

        post {}
      end
    end
  end
end
