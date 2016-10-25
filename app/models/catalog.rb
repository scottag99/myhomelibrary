class Catalog < ApplicationRecord
  has_many :catalog_entries, :dependent => :delete_all
end
