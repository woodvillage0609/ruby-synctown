class CommentsController < ApplicationController

before_action :authenticate_user!

def create

	@article = Article.find(params[:article_id])
	@comment = @article.comments.create(comment_params)
	@comment.user_id = current_user.id
	@comment.article_id = @article.id

	if @comment.save
		redirect_to article_path(@article)
	else
		render 'new'
	end
end

def destroy
	@article = Article.find(params[:article_id])
	@comment = @article.comments.find(params[:id])
	@comment.destroy

	redirect_to article_path(@article)
end

	private

	def comment_params
	
	params.require(:comment).permit(:body)
	
	end 
end
