class Campaign < ApplicationRecord
  belongs_to :organization
  has_many :wishlists, :dependent => :destroy
  has_many :campaign_catalogs, :dependent => :delete_all
  has_many :catalogs, through: :campaign_catalogs
  has_many :donations
  has_many :campaign_survey_configs
  belongs_to :prek_k_source, class_name: "Catalog", foreign_key: "prek_k_source_id", optional: true
  belongs_to :first_fifth_source, class_name: "Catalog", foreign_key: "first_fifth_source_id", optional: true

  validates :prek_k_source_id, presence: true, if: :use_packs?
  validates :first_fifth_source_id, presence: true, if: :use_packs?
end
