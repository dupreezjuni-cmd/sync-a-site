class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :authenticate_user!
  
  # Pundit setup for Rails 7.1+ (without :only/:except that trigger action checks)
  after_action :verify_authorized, unless: :skip_pundit_authorization?
  after_action :verify_policy_scoped, if: :should_verify_policy_scoped?, unless: :skip_pundit?
  
  # Redirect to dashboard after login
  def after_sign_in_path_for(resource)
    dashboard_path
  end
  
  # Redirect to root after logout
  def after_sign_out_path_for(resource)
    root_path
  end
  
  # Rescue from Pundit authorization errors
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  helper_method :feature_enabled?
  
  private
  
  def skip_pundit?
    # Skip Pundit for:
    # 1. All Devise controllers (including custom ones in users namespace)
    # 2. HomeController
    # 3. Any controller under users/ (custom Devise controllers)
    devise_controller? || 
    controller_name == 'home' ||
    controller_path.start_with?('users/')
  end
  
  def skip_pundit_authorization?
    # Skip authorization verification for index actions (handled by policy_scoped)
    skip_pundit? || action_name == 'index'
  end
  
  def should_verify_policy_scoped?
    # Only verify policy scoped for index actions
    action_name == 'index' && !skip_pundit?
  end
  
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end
  
  def require_feature(feature_key)
    unless feature_enabled?(feature_key)
      redirect_to dashboard_path, alert: "This feature is not enabled for your account."
    end
  end
end