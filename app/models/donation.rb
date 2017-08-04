class Donation < ApplicationRecord
  belongs_to :wishlist, optional: true
  belongs_to :campaign, optional: true
end
