class Organization < ApplicationRecord
  has_many :campaigns, :dependent => :delete_all
end
