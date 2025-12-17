# app/controllers/tenants_controller.rb
class TenantsController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped
  
  def index
    # Only allow super_admin and agency_admin
    unless current_user.super_admin? || current_user.agency_admin?
      redirect_to dashboard_path, alert: "You are not authorized to view this page."
      return
    end

    if current_user.super_admin?
      @tenants = Tenant.all.includes(:agency)
    elsif current_user.agency_admin?
      @tenants = Tenant.where(agency_id: current_user.agency_id).includes(:agency)
    end
  end
  
  def show
    @tenant = Tenant.find(params[:id])
  end
end