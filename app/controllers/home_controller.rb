class HomeController < ApplicationController
  def index
    if current_user.present?
      redirect_to notes_path
    end
  end
end
