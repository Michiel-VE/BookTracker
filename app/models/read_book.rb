class ReadBook < ApplicationRecord
  validates :user, uniqueness: { scope: :book_id,
    message: "You have read this book already!" }
  belongs_to :user
end
