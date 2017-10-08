class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.integer :requestor_id
      t.integer :target_id

      t.timestamps
    end
    add_index :subscriptions, [:requestor_id, :target_id], unique: true
  end
end
