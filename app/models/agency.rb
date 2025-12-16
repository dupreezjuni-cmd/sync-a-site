class Agency < ApplicationRecord
  # Relationships
  has_many :tenants, dependent: :destroy
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
  
  # Settings accessors
  store_accessor :settings, :plan, :max_tenants, :max_users, :features
end