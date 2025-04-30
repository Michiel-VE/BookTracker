class Like < ApplicationRecord
  validates :user, uniqueness: { scope: :book,
    message: "You have liked this book already!" }

  belongs_to :user
end
