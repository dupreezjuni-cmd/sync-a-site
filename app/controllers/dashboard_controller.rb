class DashboardController < ApplicationController
  # Skip policy scoping for dashboard since we're not showing a collection
  skip_after_action :verify_policy_scoped, only: [:index]
  
  def index
    @user = current_user
    authorize @user, policy_class: DashboardPolicy
  end
end