class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :balance,         :null => false, :default => 0
      t.integer :overdraft,       :null => false, :default => 0
      t.integer :overdraft_limit, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
