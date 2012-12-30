class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.text :url
      t.text :description

      t.timestamps
    end
  end
end
