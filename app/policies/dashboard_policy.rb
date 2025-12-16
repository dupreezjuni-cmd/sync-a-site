class DashboardPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true # All authenticated users can view dashboard
  end
end