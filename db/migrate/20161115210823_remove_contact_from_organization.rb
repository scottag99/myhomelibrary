class RemoveContactFromOrganization < ActiveRecord::Migration[5.0]
  def change
    remove_column :organizations, :contact_name, :string
    remove_column :organizations, :contact_email, :string
  end
end
