# db/migrate/[timestamp]_create_features.rb
class CreateFeatures < ActiveRecord::Migration[8.1]
  def change
    create_table :features do |t|
      t.string :name, null: false
      t.string :key, null: false
      t.text :description
      t.string :version, default: "1.0.0"
      t.text :dependencies
      t.text :default_config
      t.boolean :is_core, default: false
      t.boolean :is_agency_only, default: false
      t.string :category
      t.integer :display_order, default: 0
      
      t.timestamps
    end
    
    add_index :features, :key, unique: true
    add_index :features, :category
    add_index :features, :is_core
  end
end