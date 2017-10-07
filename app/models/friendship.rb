class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  def self.add(user_email:, friend_email:)
    user = User.find_or_create_by(email: user_email)
    friend = User.find_or_create_by(email: friend_email)

    if user != friend
      user.friendships.find_or_create_by(friend: friend)
      friend.friendships.find_or_create_by(friend: user)
    end
  end

  def self.for(email:)
    user = User.find_by(email: email)

    if user
      user.friendships
    else
      none
    end
  end
end
