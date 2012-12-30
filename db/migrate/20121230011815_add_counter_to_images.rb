class AddCounterToImages < ActiveRecord::Migration
  def change
    add_column :images, :counter, :integer, default: 0
  end
end
