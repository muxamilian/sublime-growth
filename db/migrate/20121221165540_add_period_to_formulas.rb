class AddPeriodToFormulas < ActiveRecord::Migration
  def change
    add_column :formulas, :period, :integer, default: 0
  end
end
