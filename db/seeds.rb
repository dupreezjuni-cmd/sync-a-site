# db/seeds.rb
puts "=== Sync-a-Site Seeding ==="
puts "Creating initial data..."

# First, create/update features registry
puts "Step 0: Creating/Updating Features Registry..."
require_relative 'seeds/features'

# Clear existing data (but NOT features, since they're registry data)
User.destroy_all if User.any?
Tenant.destroy_all if Tenant.any?
Agency.destroy_all if Agency.any?

puts "Step 1: Creating Agency..."

begin
  # 1. Create the main agency (SyncTech)
  sync_agency = Agency.create!(
    name: "SyncTech Agency",
    subdomain: "sync",
    status: :active,
    settings: {
      plan: "enterprise",
      max_tenants: 100,
      max_users: 500,
      features: ["multi_tenant", "site_builder", "ecommerce"]
    }
  )
  puts "✅ Created agency: #{sync_agency.name}"
rescue => e
  puts "❌ Failed to create agency: #{e.message}"
  exit
end

puts "Step 2: Creating Agency Tenant..."

begin
  # 2. Create the agency's own tenant - USE agency_id instead of agency
  agency_tenant = Tenant.create!(
    name: "SyncTech Agency (Internal)",
    subdomain: "sync-agency",
    status: :active,
    agency_id: sync_agency.id,  # Use agency_id instead of agency
    is_agency_tenant: true
  )
  puts "✅ Created agency tenant: #{agency_tenant.name}"
rescue => e
  puts "❌ Failed to create agency tenant: #{e.message}"
  exit
end

puts "Step 3: Creating Users..."

begin
  # 3. Create super admin
  User.create!(
    email: "admin@sync-a-site.com",
    password: "password123",
    password_confirmation: "password123",
    role: :super_admin,
    agency_id: sync_agency.id,
    tenant_id: agency_tenant.id
  )
  puts "✅ Created super admin: admin@sync-a-site.com"
rescue => e
  puts "❌ Failed to create super admin: #{e.message}"
end

begin
  # 4. Create agency admin
  User.create!(
    email: "agency@sync-a-site.com",
    password: "password123",
    password_confirmation: "password123",
    role: :agency_admin,
    agency_id: sync_agency.id,
    tenant_id: agency_tenant.id
  )
  puts "✅ Created agency admin: agency@sync-a-site.com"
rescue => e
  puts "❌ Failed to create agency admin: #{e.message}"
end

begin
  # 5. Create agency user
  User.create!(
    email: "staff@sync-a-site.com",
    password: "password123",
    password_confirmation: "password123",
    role: :agency_user,
    agency_id: sync_agency.id,
    tenant_id: agency_tenant.id
  )
  puts "✅ Created agency user: staff@sync-a-site.com"
rescue => e
  puts "❌ Failed to create agency user: #{e.message}"
end

puts "Step 4: Creating Client Tenant..."

begin
  # 6. Create a client tenant under the agency
  demo_tenant = Tenant.create!(
    name: "Demo Client",
    subdomain: "demo",
    status: :active,
    agency_id: sync_agency.id,  # Use agency_id instead of agency
    is_agency_tenant: false
  )
  puts "✅ Created client tenant: #{demo_tenant.name}"
rescue => e
  puts "❌ Failed to create client tenant: #{e.message}"
  exit
end

puts "Step 5: Creating Client Users..."

begin
  # 7. Create client admin
  User.create!(
    email: "client@demo.com",
    password: "password123",
    password_confirmation: "password123",
    role: :client_admin,
    agency_id: sync_agency.id,
    tenant_id: demo_tenant.id
  )
  puts "✅ Created client admin: client@demo.com"
rescue => e
  puts "❌ Failed to create client admin: #{e.message}"
end

begin
  # 8. Create client user
  User.create!(
    email: "user@demo.com",
    password: "password123",
    password_confirmation: "password123",
    role: :client_user,
    agency_id: sync_agency.id,
    tenant_id: demo_tenant.id
  )
  puts "✅ Created client user: user@demo.com"
rescue => e
  puts "❌ Failed to create client user: #{e.message}"
end

puts "Step 6: Enabling Core Features for Tenants..."

begin
  # Enable core features for agency tenant
  puts "Enabling core features for agency tenant..."
  core_features = Feature.where(is_core: true)
  core_features.each do |feature|
    agency_tenant.enable_feature(feature.key, feature.default_config)
    puts "  ✅ Enabled #{feature.name} for agency tenant"
  end
rescue => e
  puts "❌ Failed to enable core features for agency tenant: #{e.message}"
end

begin
  # Enable core features for demo tenant
  puts "Enabling core features for demo tenant..."
  core_features.each do |feature|
    demo_tenant.enable_feature(feature.key, feature.default_config)
    puts "  ✅ Enabled #{feature.name} for demo tenant"
  end
rescue => e
  puts "❌ Failed to enable core features for demo tenant: #{e.message}"
end

puts "\n=== Login Credentials ==="
puts "Super Admin: admin@sync-a-site.com / password123"
puts "Agency Admin: agency@sync-a-site.com / password123"
puts "Agency User: staff@sync-a-site.com / password123"
puts "Client Admin: client@demo.com / password123"
puts "Client User: user@demo.com / password123"
puts "\n=== Final Counts ==="
puts "Agencies: #{Agency.count}"
puts "Tenants: #{Tenant.count}"
puts "Users: #{User.count}"
puts "Features: #{Feature.count}"
puts "Enabled Features (agency): #{agency_tenant.enabled_features.count}"
puts "Enabled Features (demo): #{demo_tenant.enabled_features.count}"
puts "\nSeed data created successfully!"