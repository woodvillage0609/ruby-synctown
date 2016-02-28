class PostsController < ApplicationController

before_action :authenticate_user!

def create
    @note = Note.find(params[:note_id])
    @post = @note.posts.create(post_params)
    @post.user_id = current_user.id
    @post.note_id = @note.id
    
    if @post.save
    redirect_to note_path(@note)
    else
    render 'new'
    end
  end

 def destroy
    @note = Note.find(params[:note_id])
    @post = @note.posts.find(params[:id])
    @post.destroy
    redirect_to note_path(@note)
  end

  private
    def post_params
      params.require(:post).permit(:body)
    end

end
