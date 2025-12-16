class User < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Role enum
  enum :role, {
    super_admin: 0,
    agency_admin: 1,
    agency_user: 2,
    client_admin: 3,
    client_user: 4
  }, default: :client_user
  
  # Relationships
  belongs_to :agency, optional: true
  belongs_to :tenant, optional: true
  
  # Validations
  validates :email, presence: true, uniqueness: true
  
  # Scopes
  scope :agency_staff, -> { where(role: [:agency_admin, :agency_user]) }
  scope :client_staff, -> { where(role: [:client_admin, :client_user]) }
  
  # Methods
  def agency_staff?
    agency_admin? || agency_user?
  end
  
  def client_staff?
    client_admin? || client_user?
  end
  
  # Ensure user belongs to either agency or tenant (or both for super_admin)
  def belongs_to_agency_or_tenant?
    agency.present? || tenant.present?
  end
end