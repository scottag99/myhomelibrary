class AddIsClassroomSponsorshipToDonation < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :is_classroom_sponsorship, :boolean
  end
end
