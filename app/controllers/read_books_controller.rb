class ReadBooksController < ApplicationController
    def create
        @read_book = current_user.read_books.new(read_params)

        unless @read_book.save
          flash[:notice] = @read_book.errors.full_messages.to_sentence
        end
      
        redirect_to request.referer || root_path
    end

    def destroy
        @read_book = current_user.read_books.find_by(book_id: params[:id])

        @read_book.destroy

        redirect_to request.referer || root_path
    end

    private

    def read_params
        params.require(:read_book).permit(:book_id)
    end
end
