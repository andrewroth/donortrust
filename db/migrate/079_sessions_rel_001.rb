class SessionsRel001 < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.column :sessid,     :string
      t.column :data,       :text
      t.column :updated_at, :datetime
      t.column :created_at, :datetime
    end
    
    add_index :sessions, :sessid
  end

  def self.down
    drop_table :sessions
  end
end
