class User < ApplicationRecord
  has_many :friendships

  has_many :blocks, foreign_key: 'requestor_id'

  has_many :block_requests, class_name: 'Block', foreign_key: 'target_id'
  has_many :block_users, through: :block_requests, source: :requestor

  has_many :follows, class_name: 'Subscription', foreign_key: 'requestor_id'

  has_many :subscriptions, foreign_key: 'target_id'
  has_many :followers, through: :subscriptions, source: :requestor

  def blocks?(target)
    blocks.where(target: target).any?
  end
end
