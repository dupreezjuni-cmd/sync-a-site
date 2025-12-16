class Tenant < ApplicationRecord
  # Relationships
  has_many :users, dependent: :destroy
  
  # Validations
  validates :name, presence: true
  validates :subdomain, 
    presence: true, 
    uniqueness: true,
    format: { with: /\A[a-z0-9]+\z/, message: "only lowercase letters and numbers" }
  
  # Status enum
  enum :status, {
    active: 0,
    suspended: 1,
    pending: 2
  }, default: :active
end