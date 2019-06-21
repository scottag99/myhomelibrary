require 'csv'

def read_kimbia
  CSV.foreach(File.join(Rails.root, 'lib', 'kimbia_export.csv'), headers: true) do |row|
    entry = row.to_hash
    add_donation(entry['Confirmation Code'], entry['Price with Discount'], entry['Wishlist ID'] || "")
  end
end

def add_donation(confirmation_code, amount = nil, id_list = "")
  return if Donation.where(confirmation_code: confirmation_code).count > 0
  @wishlists = Wishlist.joins([{:campaign => :organization}]).where("wishlists.id in (?)", id_list.split(",").map(&:to_i)).all
  if @wishlists.count > 0
    amt = amount.to_d/@wishlists.count unless amount.nil? || @wishlists.count == 0
    @wishlists.each do |w|
      @donation = w.donations.create!({:confirmation_code => confirmation_code,
        :amount => amt,
        :is_classroom_sponsorship => false,
        :is_in_kind => false})
    end
  else
    @donation = Donation.create!({:confirmation_code => confirmation_code,
      :amount => amount,
      :is_in_kind => false})
  end
end
