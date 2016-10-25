class Campaign < ApplicationRecord
  belongs_to :organization
  has_many :wishlists, :dependent => :delete_all
end
