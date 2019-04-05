class AddInKindFieldsToDonation < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :is_in_kind, :boolean
    add_column :donations, :in_name_of, :string
    add_column :donations, :in_kind_message, :string
  end
end
