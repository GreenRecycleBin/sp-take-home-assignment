class User < ApplicationRecord
  has_many :friendships

  has_many :blocks, foreign_key: 'requestor_id'

  def blocks?(target)
    blocks.where(target: target).any?
  end
end
