class Organization < ApplicationRecord
  has_many :campaigns, :dependent => :destroy
  has_many :partners, :dependent => :destroy
end
