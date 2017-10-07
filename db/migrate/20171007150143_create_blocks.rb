class CreateBlocks < ActiveRecord::Migration[5.1]
  def change
    create_table :blocks do |t|
      t.integer :requestor_id
      t.integer :target_id

      t.timestamps
    end
    add_index :blocks, [:requestor_id, :target_id], unique: true
  end
end
