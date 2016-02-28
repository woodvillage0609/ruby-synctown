class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :like_notes, :post_notes, :following, :followers, :subscribed]
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @notes=@user.notes
    @title = "User's Note List"
  end

  # GET /users/new
 

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
 

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    file=params[:user][:image]
    @user.set_image(file)

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def like_notes
    @notes = @user.like_notes
    @title = "User's 'Good' List"

    render :show
  end

  def post_notes
    @notes = @user.post_notes
    @title = "User's comments"

    render :show
  end

  # DELETE /users/1
  # DELETE /users/1.json
  
  def following
    @title = "Following"
    @users = @user.following.paginate(page: params[:page])
   render 'show_follow'
  end

  def followers
    @title = "Followers"
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def subscribed
    @notes = Note.subscribed @user.following
    @title = "User's following notes"
    render :show 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email)
    end

    def correct_user
      user=User.find(params[:id])
      if !current_user?(user)
        redirect_to root_path
      end
    end
end
