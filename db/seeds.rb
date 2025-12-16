puts "=== Sync-a-Site Seeding ==="
puts "Creating initial data..."

# Clear existing data
User.destroy_all if User.any?
Tenant.destroy_all if Tenant.any?

# Create the main agency tenant (SyncTech)
agency_tenant = Tenant.create!(
  name: "SyncTech Agency",
  subdomain: "agency",
  status: :active
)

puts "Created agency tenant: #{agency_tenant.name}"

# Create super admin user
User.create!(
  email: "admin@sync-a-site.com",
  password: "password123",
  password_confirmation: "password123",
  role: :super_admin,
  tenant_id: agency_tenant.id
)

puts "Created super admin: admin@sync-a-site.com"

# Create a sample client tenant
client_tenant = Tenant.create!(
  name: "Demo Client",
  subdomain: "demo",
  status: :active
)

puts "Created client tenant: #{client_tenant.name}"

# Create client admin
User.create!(
  email: "client@demo.com",
  password: "password123",
  password_confirmation: "password123",
  role: :client_admin,
  tenant_id: client_tenant.id
)

puts "Created client admin: client@demo.com"

# Create a regular client user
User.create!(
  email: "user@demo.com",
  password: "password123",
  password_confirmation: "password123",
  role: :client_user,
  tenant_id: client_tenant.id
)

puts "Created client user: user@demo.com"

puts "\n=== Login Credentials ==="
puts "Super Admin: admin@sync-a-site.com / password123"
puts "Client Admin: client@demo.com / password123"
puts "Client User: user@demo.com / password123"
puts "\nSeed data created successfully!"