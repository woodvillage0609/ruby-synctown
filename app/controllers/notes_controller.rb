class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy, :liking_users]

  before_action :correct_user, only: [:edit, :update]

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all.order(created_at: :desc)
    @random_notes = Note.all.order("RANDOM()")
    @notes_by_month = Note.select(:title, :id, :created_at).order(created_at: :desc).group_by { |note| note.created_at.beginning_of_month }
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @random_notes=Note.where.not(id:@note).order("RANDOM()")
  end

  # GET /notes/new
  def new
    @note = Note.new
  end


  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = current_user.notes.build(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def liking_users
    @users = @note.liking_users
  end

  def category_good
    @notes = Note.where(note_category_id:1).order(created_at: :desc)
    render 'index'
  end

  def category_bad
    @notes = Note.where(note_category_id:2).order(created_at: :desc)
    render 'index'
  end

  def notes_by_month
    @notes = Note.where('extract(year from created_at) = ?', params[:year]).where('extract(month from created_at) = ?', params[:month]).order(created_at: :desc)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:title, :content, :photo, :note_category_id)
    end

    def correct_user
      note=Note.find(params[:id])
      if !current_user?(note.user)
        redirect_to root_path
      end
    end


end
