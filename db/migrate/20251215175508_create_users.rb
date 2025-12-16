class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      # Devise required fields
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      
      # Devise optional fields
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      
      # Custom fields for Sync-a-Site
      t.integer :role, default: 3  # 3 = client_user (default)
      t.references :tenant, foreign_key: true
      
      t.timestamps null: false
    end
    
    # Add indexes
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end