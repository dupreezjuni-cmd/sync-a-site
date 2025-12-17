class Tenant < ApplicationRecord
  # Relationships
  belongs_to :agency
  has_many :users, dependent: :destroy
  
  # Validations
  validates :name, presence: true
  validates :subdomain, 
    presence: true, 
    uniqueness: true,
    format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, message: "only lowercase letters, numbers, and hyphens (no spaces or special chars)" }
  
  # Status enum
  enum :status, {
    active: 0,
    suspended: 1,
    pending: 2
  }, default: :active

  # Flag to identify agency tenants
  attribute :is_agency_tenant, :boolean, default: false
  has_many :tenant_features, dependent: :destroy
  has_many :features, through: :tenant_features
  
  def enabled_features
    tenant_features.where(is_enabled: true).includes(:feature)
  end
  
  def feature_enabled?(feature_key)
    tenant_features.joins(:feature).where(features: { key: feature_key }, is_enabled: true).exists?
  end
  
  def enable_feature(feature_key, config = {})
    feature = Feature.find_by(key: feature_key)
    return false unless feature
    
    tenant_feature = tenant_features.find_or_initialize_by(feature: feature)
    tenant_feature.configuration = config
    tenant_feature.enable!
    end
  
  def disable_feature(feature_key)
    tenant_features.joins(:feature).where(features: { key: feature_key }).first&.disable!
  end
end