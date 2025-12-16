class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  # Redirect to dashboard after login
  def after_sign_in_path_for(resource)
    dashboard_path
  end
  
  # Redirect to root after logout
  def after_sign_out_path_for(resource)
    root_path
  end
end
