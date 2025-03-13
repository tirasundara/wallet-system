class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :symbol, null: false
      t.string :name, null: false
      t.decimal :current_price, precision: 10, scale: 2, default: 0

      t.timestamps
    end
    add_index :stocks, :symbol, unique: true
  end
end
