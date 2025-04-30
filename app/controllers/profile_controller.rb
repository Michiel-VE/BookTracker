class ProfileController < ApplicationController
    before_action :authenticate_user!
    before_action :get_total_number_of_read_pages, only: [:show_profile]
  
    def show_profile
        @total_read_books = current_user.read_books.count
        @user = current_user
    end

    def update_goal
      @user = current_user
      if @user.update(goal_params)
        redirect_to profile_path, notice: "Goal updated!"
      else
        redirect_to profile_path, alert: "Could not update goal."
      end
    end
  
    private
  
    def get_total_number_of_read_pages
      @read = current_user.read_books
      @read_books = @read.map do |read_book|
        OpenLibraryService.fetch_book_from_api(read_book.book_id)
      end.compact
  
      @total_pages_read = @read_books.sum { |book| book[:pages].to_i }
    end

    def goal_params
      params.require(:user).permit(:goal)
    end
  end
  