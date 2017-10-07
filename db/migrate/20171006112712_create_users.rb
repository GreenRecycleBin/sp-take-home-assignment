class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, limit: 254

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
