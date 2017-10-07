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

  def self.common(user_email:, friend_email:)
    user = User.find_by(email: user_email)
    friend = User.find_by(email: friend_email)

    return User.none unless user && friend

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

    result = ActiveRecord::Base.connection.raw_connection.execute(query, [user.id, friend.id])
    common_friend_ids = result.map { |row| row[column_name] }

    User.where(id: common_friend_ids)
  end
end
