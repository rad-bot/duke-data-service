class AddEventualConsistencySupport < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :is_consistent, :boolean
    add_column :uploads, :is_consistent, :boolean
  end
end
