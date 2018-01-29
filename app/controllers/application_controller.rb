class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :store_user_location!, if: :storable_location?
  before_action :devise_permitted_parameters, if: :devise_controller?

  if Rails.env.production?
    rescue_from Exception, with: :render_500
  end
  rescue_from User::AccessDenied, with: :access_denied
  rescue_from ActiveRecord::RecordNotFound,
    ActionController::UnknownController,
    ActionController::UnknownHttpMethod,
    ActionController::UnknownFormat,
    ActionController::RoutingError, with: :render_404

  def access_denied exception
    default_message = 'Unauthorized to access this page'
    flash[:error] = exception.message == exception.class.to_s ? default_message : exception.message
    respond_to do |type|
      type.html { redirect_to root_path }
      type.json { render json: { success: true, flash: flash, window_redirect: root_path, }, status: 200 }
    end
  end

  def render_404
    respond_to do |type|
      type.html { render file: "#{Rails.root}/public/404.html", status: '404 Not Found' }
      type.all  { render body: nil, status: '404 Not Found' }
    end
  end
  alias routing_error render_404

  def render_500
    respond_to do |type|
      type.html { render file: "#{Rails.root}/public/500.html", status: '500 Error' }
      type.all  { render body: nil, status: '500 Error' }
    end
  end

  protected

  def devise_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
