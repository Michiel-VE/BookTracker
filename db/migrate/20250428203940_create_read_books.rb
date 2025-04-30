class CreateReadBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :read_books do |t|
      t.references :user, null: false, foreign_key: true
      t.string :book_id

      t.timestamps
    end

    add_index :read_books, [:user_id, :book_id], unique: true
  end
end
