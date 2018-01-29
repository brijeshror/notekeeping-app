class Users::Devise::SessionsController < ::Devise::SessionsController
  def destroy
    super do
      flash.notice = find_message(:signed_out)
      render json: {
        success: true,
        flash: flash,
        window_redirect: after_sign_out_path_for(resource_name)
      }, status: 200
      return
    end
  end
end
