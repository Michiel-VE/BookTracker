class BooksController < ApplicationController
  before_action :authenticate_user!

  # def search
  #   base_link_title = "https://openlibrary.org/search.json?title="
  #   base_link_isbn = "https://openlibrary.org/search.json?isbn="
  #   book_search_param = params[:title]

  #   @books = []
  #   @search_title = book_search_param

  #   if book_search_param.present?
  #     response = HTTParty.get("#{base_link_title}#{book_search_param}")

  #     if response.success?
  #       @books = response["docs"]
  #     end

  #     if @books.empty?
  #       isbn_response = HTTParty.get("#{base_link_isbn}#{book_search_param.to_s.gsub(/[ _]/, '')}")

  #       if isbn_response.success?
  #         @books = isbn_response["docs"]
  #       end
  #     end
  #   end
  # end

  def search
    base_link_title = "https://openlibrary.org/search.json?title="
    base_link_isbn = "https://openlibrary.org/search.json?isbn="
    book_search_param = params[:title]
    page = (params[:page] || 1).to_i
    limit = 9
  
    @books = []
    @search_title = book_search_param
    @page = page
    @limit = limit
    @total_results = 0
    @total_pages = 1
  
    if book_search_param.present?
      response = HTTParty.get("#{base_link_title}#{URI.encode_www_form_component(book_search_param)}&page=#{page}&limit=#{limit}")
  
      if response.success?
        parsed = response.parsed_response
        @books = parsed["docs"]
        @total_results = parsed["numFound"].to_i
      end
  
      # fallback to ISBN search if no results
      if @books.empty?
        isbn_query = book_search_param.to_s.gsub(/[ _]/, '')
        isbn_response = HTTParty.get("#{base_link_isbn}#{isbn_query}&page=#{page}&limit=#{limit}")
  
        if isbn_response.success?
          parsed = isbn_response.parsed_response
          @books = parsed["docs"]
          @total_results = parsed["numFound"].to_i
        end
      end
  
      @total_pages = (@total_results.to_f / limit).ceil
    end
  end
  

  def show_liked_books
    @likes = current_user.likes

    @liked_books = @likes.map do |like|
      OpenLibraryService.fetch_book_from_api(like.book)
    end.compact
  end

  def show_read_books
    @read = current_user.read_books

    @read_books = @read.map do |read_book|
      OpenLibraryService.fetch_book_from_api(read_book.book_id)
    end.compact
  end
end
