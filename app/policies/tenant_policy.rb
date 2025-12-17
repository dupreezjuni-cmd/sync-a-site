# app/policies/tenant_policy.rb
class TenantPolicy
  attr_reader :user, :tenant

  def initialize(user, tenant)
    @user = user
    @tenant = tenant
  end

  def index?
    user.super_admin? || user.agency_admin?
  end

  def show?
    user.super_admin? || 
    (user.agency_admin? && user.agency_id == tenant.agency_id) ||
    user.tenant_id == tenant.id
  end

  def create?
    user.super_admin? || user.agency_admin?
  end

  def update?
    user.super_admin? || 
    (user.agency_admin? && user.agency_id == tenant.agency_id)
  end

  def destroy?
    user.super_admin?
  end

  # Add this method for admin actions
  def admin?
    user.super_admin? || user.agency_admin?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.super_admin?
        scope.all
      elsif user.agency_admin?
        scope.where(agency_id: user.agency_id)
      else
        scope.where(id: user.tenant_id)
      end
    end
  end
end