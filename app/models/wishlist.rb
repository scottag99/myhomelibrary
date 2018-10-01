class Wishlist < ApplicationRecord
  belongs_to :campaign
  has_many :wishlist_entries, :dependent => :destroy
  has_many :donations, :dependent => :destroy
  has_many :catalog_entries, through: :wishlist_entries

  scope :has_books, -> { where('wishlist_entry_count > 0') }

  validates :teacher, :presence => true
  validates :reader_name, :presence => true
  validates :grade, :presence => true

  after_initialize do
    if self.new_record? && self.external_id.blank?
      # values will be available for new record forms.
      self.external_id = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
    end
  end

  def public_name
    sections = reader_name.split(',')
    case sections.size
      when 1
        parts = reader_name.split
      when 2
        #Need to determine if this is first name last or name with sufffix
        if sections[0].split.size == 1
          # probably firstNameLast situation
          parts = sections.reverse
        else
          # probably full name with suffix
          parts = sections[0].split
        end
      when 3
        # oh boy, multiple commas in the name!
        # our guess is this in the form of Doe, John, Jr.
        sections.pop
        parts = sections.reverse
      else
        # no idea what screwed up data this would be. To be safe,
        # just going to show initials
        parts = sections.collect{|part| part.slice(0).strip}
    end
    if parts.count >= 2
      "#{parts.first.strip} #{parts.last.slice(0).strip}."
    else
      reader_name
    end
  end
end
