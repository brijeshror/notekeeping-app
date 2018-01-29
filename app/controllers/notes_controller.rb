class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  before_action :authorize_note!, only: [:show, :edit, :update, :destroy]

  def index
    @notes = Note.all
  end

  def show
  end

  def new
    @note = current_user.notes.new
  end

  def edit
  end

  def create
    note_is_saved = begin
      Note.transaction do
        @note = current_user.notes.new(note_params)
        @note.assign_tags(params[:tags])
        @note.save!
      end
    rescue ActiveRecord::RecordInvalid => e
      false
    end
    if note_is_saved
      redirect_to @note, notice: 'Note was successfully created.'
    else
      render :new
    end
  end

  def update
    @note.assign_tags(params[:tags])
    if @note.update(note_params)
      redirect_to @note, notice: 'Note was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @note.destroy
    flash.notice = 'Note was successfully destroyed.'
    render json: {
      success: true, flash: flash, window_redirect: notes_url,
    }, status: 200
  end

  private
    def set_note
      @note = Note.find(params[:id])
    end

    def note_params
      params.require(:note).permit(:note)
    end

    def authorize_note!
      if ['destroy'].include?(action_name) && @note.user != current_user
        raise User::AccessDenied.new('Only creator owner can remove')
      end
      if ['edit', 'update'].include?(action_name) && !@note.updaters.include?(current_user)
        raise User::AccessDenied.new('User should be a owner/updater')
      end
      if ['show'].include?(action_name) && !@note.readers.include?(current_user)
        raise User::AccessDenied.new('User should be a reader/owner/updater')
      end
    end
end
