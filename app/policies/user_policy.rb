class UserPolicy < ApplicationPolicy
  def index?
    user.super_admin? || user.agency_admin?
  end

  def show?
    user.super_admin? || user.agency_admin? || record == user
  end

  def create?
    user.super_admin? || user.agency_admin?
  end

  def update?
    user.super_admin? || user.agency_admin? || record == user
  end

  def destroy?
    user.super_admin? || (user.agency_admin? && !record.super_admin?)
  end

  class Scope
    def resolve
      if user.super_admin?
        scope.all
      elsif user.agency_admin?
        scope.where(tenant_id: user.tenant_id)
      else
        scope.where(id: user.id)
      end
    end
  end
end