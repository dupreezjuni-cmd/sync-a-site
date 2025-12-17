# app/models/feature.rb
class Feature < ApplicationRecord
  validates :name, :key, presence: true
  validates :key, format: { with: /\A[a-z_][a-z0-9_]*\z/, message: "must be snake_case" }
  
  # Fix: In Rails 8.1, serialize takes keyword arguments
  serialize :dependencies, coder: JSON
  serialize :default_config, coder: JSON
  
  has_many :tenant_features, dependent: :destroy
  has_many :tenants, through: :tenant_features
  
  # Class methods for feature registry
  class << self
    def register(name:, key:, **options)
      Feature.find_or_create_by(key: key) do |feature|
        feature.name = name
        feature.description = options[:description]
        feature.version = options[:version] || "1.0.0"
        feature.dependencies = options[:dependencies] || []
        feature.default_config = options[:default_config] || {}
        feature.is_core = options[:is_core] || false
        feature.is_agency_only = options[:is_agency_only] || false
        feature.category = options[:category] || "general"
        feature.display_order = options[:display_order] || 0
      end
    end
    
    def available_for_tenant(tenant)
      all.where(is_agency_only: false).or(where(is_agency_only: true, id: Feature.joins(:tenants).where(tenants: { agency_id: tenant.agency_id })))
    end
  end
end