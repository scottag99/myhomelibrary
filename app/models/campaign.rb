class Campaign < ApplicationRecord
  belongs_to :organization
  has_many :wishlists, :dependent => :destroy
  has_many :campaign_catalogs, :dependent => :delete_all
  has_many :catalogs, through: :campaign_catalogs
end
