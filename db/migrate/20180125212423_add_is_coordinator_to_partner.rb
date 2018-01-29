class AddIsCoordinatorToPartner < ActiveRecord::Migration[5.0]
  def change
    add_column :partners, :is_coordinator, :boolean, default: false
  end
end
