# app/controllers/users_controller.rb
class UsersController < ApplicationController
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
      @users = User.all.includes(:tenant, :agency)
    elsif current_user.agency_admin?
      @users = User.where(agency_id: current_user.agency_id).includes(:tenant, :agency)
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
end