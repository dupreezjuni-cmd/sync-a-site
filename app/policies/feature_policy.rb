# app/policies/feature_policy.rb
class FeaturePolicy
  attr_reader :user, :feature

  def initialize(user, feature)
    @user = user
    @feature = feature
  end

  def index?
    user.super_admin? || user.agency_admin?
  end

  def show?
    user.super_admin? || user.agency_admin?
  end

  def create?
    user.super_admin?
  end

  def update?
    user.super_admin? || user.agency_admin?
  end

  def destroy?
    user.super_admin?
  end

  # Custom action for admin management
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
        # Agency admins can see all features except super-admin only ones
        scope.all
      else
        # Regular users can't see any features in admin
        scope.none
      end
    end
  end
end