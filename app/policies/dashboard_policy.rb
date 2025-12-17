# app/policies/dashboard_policy.rb
class DashboardPolicy
  attr_reader :user, :dashboard

  def initialize(user, dashboard)
    @user = user
    @dashboard = dashboard
  end

  def index?
    # All logged-in users can access the dashboard
    user.present?
  end
end