# app/models/tenant_feature.rb
class TenantFeature < ApplicationRecord
  belongs_to :tenant
  belongs_to :feature
  
  validates :tenant_id, uniqueness: { scope: :feature_id }
  
  # Fix: In Rails 8.1, serialize takes keyword arguments
  serialize :configuration, coder: JSON
  
  before_save :set_installed_at
  
  def enable!
    update(is_enabled: true, installed_at: Time.current)
  end
  
  def disable!
    update(is_enabled: false)
  end
  
  private
  
  def set_installed_at
    self.installed_at = Time.current if is_enabled_changed? && is_enabled?
  end
end