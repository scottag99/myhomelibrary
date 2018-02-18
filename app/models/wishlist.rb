class Wishlist < ApplicationRecord
  belongs_to :campaign
  has_many :wishlist_entries, :dependent => :destroy
  has_many :donations
  has_many :catalog_entries, through: :wishlist_entries

  scope :has_books, -> { where('wishlist_entry_count > 0') }

  validates :teacher, :presence => true
  validates :reader_name, :presence => true
  validates :grade, :presence => true

  def public_name
    firstNameLast = reader_name =~ /,/
    if firstNameLast.nil?
      parts = reader_name.split
    else #this is to handle names entered like this Johnson, Frank
      parts = reader_name.split(',').reverse
    end
    if parts.count >= 2
      "#{parts.first.strip} #{parts.last.slice(0).strip}."
    else
      reader_name
    end
  end
end
