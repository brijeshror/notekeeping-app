class NoteSharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note
  before_action :authorize_note_share!
  before_action :get_note_share, only: [:destroy]
  before_action :get_sharable_users, only: [:new, :create, :destroy]

  def new
    @note_share = @note.note_shares.new
  end

  def create
    @note_share = @note.note_shares.new(note_share_params)
    @note_share.creator = current_user
    if @note_share.save
      redirect_to @note, notice: 'Note shared successfully'
    else
      render :new
    end
  end

  def destroy
    @note_share.destroy_transitive_share
    flash.notice = 'All transitive share successfully destroyed.'
    render json: {
        success: true, flash: flash, window_redirect: note_url(@note),
    }, status: 200
  end

  private
    def set_note
      @note = Note.find(params[:note_id])
    end

    def get_note_share
      @note_share = @note.note_shares.find(params[:id])
    end

    def note_share_params
      params.require(:note_share).permit(:user_id, :access_role)
    end

    def get_sharable_users
      @sharable_users = @note.sharable_users
    end

    def authorize_note_share!
      if ['new', 'create', 'destroy'].include?(action_name) && !@note.updaters.include?(current_user)
        raise User::AccessDenied.new('User should be a updater')
      end
    end
end
