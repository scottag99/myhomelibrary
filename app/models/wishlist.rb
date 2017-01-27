class Wishlist < ApplicationRecord
  belongs_to :campaign
  has_many :wishlist_entries, :dependent => :destroy
  has_many :donations
  has_many :catalog_entries, through: :wishlist_entries

  def donation_total
    donations.sum(:amount)
  end

  def wishlist_total
    catalog_entries.sum(:price)
  end

  def public_name
    firstNameLast = reader_name =~ /,/
    if firstNameLast.nil?
      parts = reader_name.split
    else #this is to handle names entered like this Johnson, Frank
      parts = reader_name.gsub(/,/, '').split.reverse
    end
    if parts.count >= 2
      "#{parts[0]} #{parts[1].slice(0)}."
    else
      reader_name
    end
  end
end
