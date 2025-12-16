class TenantPolicy < ApplicationPolicy
  def index?
    user.super_admin? || user.agency_admin?
  end

  def show?
    user.super_admin? || 
    (user.agency_admin? && user.agency == record.agency) ||
    (user.client_staff? && record == user.tenant)
  end

  def create?
    user.super_admin? || user.agency_admin?
  end

  def update?
    user.super_admin? || user.agency_admin?
  end

  def destroy?
    user.super_admin?
  end

  class Scope
    def resolve
      if user.super_admin?
        scope.all
      elsif user.agency_admin?
        scope.where(agency_id: user.agency_id)
      elsif user.client_staff?
        scope.where(id: user.tenant_id)
      else
        scope.none
      end
    end
  end
end