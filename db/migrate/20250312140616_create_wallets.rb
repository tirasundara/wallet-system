class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.references :owner, polymorphic: true, null: false
      t.decimal :balance, precision: 10, scale: 2, default: 0, null: false

      t.timestamps
    end
    add_index :wallets, [ :owner_type, :owner_id ], unique: true
  end
end
