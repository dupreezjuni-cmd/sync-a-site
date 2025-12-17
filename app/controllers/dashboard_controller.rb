class DashboardController < ApplicationController
  # Skip policy scoping for dashboard since we're not showing a collection
  skip_after_action :verify_policy_scoped, only: [:index]
  
  def index
    @user = current_user
    authorize @user, policy_class: DashboardPolicy
    
    # Get enabled features for current tenant
    if @user.tenant
      @enabled_features = @user.tenant.enabled_features.includes(:feature).map(&:feature)
    else
      @enabled_features = []
    end
  end
  
  # You might also want to add a helper method for the view
  # but we're already adding feature_enabled? to ApplicationController
  # so no need to duplicate here
end