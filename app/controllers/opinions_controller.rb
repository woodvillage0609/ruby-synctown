class OpinionsController < ApplicationController

	before_action :authenticate_user!

def create

	@micropost = Micropost.find(params[:micropost_id])
	@opinion = @micropost.opinions.create(opinion_params)
	@opinion.user_id = current_user.id
	@opinion.micropost_id = @micropost.id

	if @opinion.save
		redirect_to mircopost_path(@micropost)
	else
		render 'new'
	end
end

def destroy
	@micropost = Micropost.find(params[:micropost_id])
	@opinion = @micropost.opinions.find(params[:id])
	@opinion.destroy

	redirect_to micropost_path(@micropost)
end

	private

	def opinion_params
	
	params.require(:opinion).permit(:body)
	
	end 

end
