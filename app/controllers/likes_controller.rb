class LikesController < ApplicationController
    def create
        @like = current_user.likes.new(like_params)

        unless @like.save
          flash[:notice] = @like.errors.full_messages.to_sentence
        end
      
        redirect_to request.referer || root_path
    end

    def destroy
        @like = current_user.likes.find_by(book: params[:id])

        @like.destroy

        redirect_to request.referer || root_path
    end

    private

    def like_params
        params.require(:like).permit(:book)
    end

end
