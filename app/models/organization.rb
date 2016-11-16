class Organization < ApplicationRecord
  has_many :campaigns, :dependent => :delete_all
  has_many :partners, :dependent => :delete_all
end
