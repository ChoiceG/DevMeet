class AddPlanToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :plan_id, :integer
  end
end
