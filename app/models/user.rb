class User < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Add role enum
  enum :role, {
    super_admin: 0,
    agency_admin: 1,
    client_admin: 2,
    client_user: 3
  }, default: :client_user
  
  # Relationships - make sure this matches the column name
  belongs_to :tenant, optional: true
  
  # Validations
  validates :email, presence: true, uniqueness: true
  
  # Callbacks
  #  after_initialize :set_default_role, if: :new_record?
  
  # private
  
#  def set_default_role
#     self.role ||= :client_user
#  end
end