class CreateLikes < ActiveRecord::Migration[8.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :book

      t.timestamps
    end

    add_index :likes, [:user_id, :book], unique: true
  end
end
