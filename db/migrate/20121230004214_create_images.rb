class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.text :uri
      t.text :description
      t.integer :counter, default: 0

      t.timestamps
    end
  end
end
