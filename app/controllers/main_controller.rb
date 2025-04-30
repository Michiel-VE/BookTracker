class MainController < ApplicationController
  def index
    if user_signed_in?
      @liked_books = current_user.likes.map { |like| OpenLibraryService.fetch_book_from_api(like.book) }.compact
      @read_books  = current_user.read_books.map { |read_book| OpenLibraryService.fetch_book_from_api(read_book.book_id) }.compact
    else
      @liked_books = []
      @read_books = []
    end
  end
end
