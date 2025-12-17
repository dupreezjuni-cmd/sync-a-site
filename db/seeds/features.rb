puts "Creating core features..."

# Core features (always available to all tenants)
Feature.register(
  name: "Dashboard",
  key: "dashboard",
  description: "Main dashboard with analytics and overview",
  is_core: true,
  category: "core",
  display_order: 1
)

Feature.register(
  name: "Pages",
  key: "pages",
  description: "Static pages management",
  is_core: true,
  category: "content",
  display_order: 2
)

Feature.register(
  name: "Navigation",
  key: "navigation",
  description: "Menu and navigation management",
  is_core: true,
  category: "content",
  display_order: 3
)

# Optional features
Feature.register(
  name: "Blog",
  key: "blog",
  description: "Blog with posts, categories, and comments",
  dependencies: ["pages"],
  default_config: { "posts_per_page" => 10, "allow_comments" => true },
  category: "content",
  display_order: 4
)

Feature.register(
  name: "E-commerce",
  key: "ecommerce",
  description: "Online store with products, cart, and checkout",
  dependencies: ["pages"],
  default_config: { "currency" => "USD", "tax_rate" => 0.0 },
  category: "ecommerce",
  display_order: 5
)

Feature.register(
  name: "Contact Forms",
  key: "contact_forms",
  description: "Customizable contact forms with email notifications",
  dependencies: ["pages"],
  default_config: { "notification_email" => "", "store_submissions" => true },
  category: "communication",
  display_order: 6
)

Feature.register(
  name: "Analytics",
  key: "analytics",
  description: "Website traffic analytics and reports",
  default_config: { "tracking_id" => "" },
  category: "analytics",
  display_order: 7
)

# Agency-only features
Feature.register(
  name: "Client Management",
  key: "client_management",
  description: "Manage clients, billing, and support",
  is_agency_only: true,
  category: "agency",
  display_order: 1
)

Feature.register(
  name: "Billing Portal",
  key: "billing_portal",
  description: "Manage subscriptions and payments",
  is_agency_only: true,
  category: "agency",
  display_order: 2
)

puts "Created #{Feature.count} features"