module Acme
  class UpdateAPI < Grape::API
    resource :update do
      params do
        requires :requestor, type: String, valid_email: true, fail_fast: true
        requires :target, type: String, valid_email: true, fail_fast: true
      end

      post do
        {success: true}
      end
    end
  end
end
