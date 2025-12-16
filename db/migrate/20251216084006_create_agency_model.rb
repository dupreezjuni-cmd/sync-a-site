class CreateAgencyModel < ActiveRecord::Migration[8.1]
  def change
    # 1. Create agencies table
    create_table :agencies do |t|
      t.string :name, null: false
      t.string :subdomain, null: false
      t.integer :status, default: 0
      t.jsonb :settings, default: {}
      t.timestamps
      
      t.index :subdomain, unique: true
    end

    # 2. Add agency_id to tenants (without automatically creating index since we'll do it manually)
    add_column :tenants, :agency_id, :bigint
    add_foreign_key :tenants, :agencies
    
    # 3. Add agency_id to users (without automatically creating index)
    add_column :users, :agency_id, :bigint
    add_foreign_key :users, :agencies
    
    # 4. Make tenant_id nullable on users (agency staff won't have a specific tenant)
    change_column_null :users, :tenant_id, true
    
    # 5. Add is_agency_tenant flag to tenants
    add_column :tenants, :is_agency_tenant, :boolean, default: false
    
    # 6. Create indexes manually (avoiding duplicates)
    add_index :tenants, :agency_id unless index_exists?(:tenants, :agency_id)
    add_index :users, :agency_id unless index_exists?(:users, :agency_id)
  end
end