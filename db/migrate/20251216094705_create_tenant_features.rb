# db/migrate/[timestamp]_create_tenant_features.rb
class CreateTenantFeatures < ActiveRecord::Migration[8.1]
  def change
    create_table :tenant_features do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :feature, null: false, foreign_key: true
      t.boolean :is_enabled, default: false
      t.text :configuration
      t.datetime :installed_at
      
      t.timestamps
    end
    
    add_index :tenant_features, [:tenant_id, :feature_id], unique: true
    add_index :tenant_features, [:tenant_id, :is_enabled]
  end
end