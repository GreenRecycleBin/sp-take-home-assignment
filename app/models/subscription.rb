class Subscription < ApplicationRecord
  belongs_to :requestor, class_name: 'User'
  belongs_to :target, class_name: 'User'

  def self.add(requestor_email:, target_email:)
    requestor = User.find_or_create_by(email: requestor_email)
    target = User.find_or_create_by(email: target_email)

    requestor.follows.find_or_create_by(target: target)
  end
end
