class CreateFormulas < ActiveRecord::Migration
  def change
    create_table :formulas do |t|
      t.text :formula
      t.text :description
      t.integer :counter, default: 0
      t.boolean :periodic, default: false
      t.integer :period, default: 0

      t.timestamps
    end
  end
end
