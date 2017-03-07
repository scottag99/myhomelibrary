class Organization < ApplicationRecord
  has_many :campaigns, :dependent => :destroy
  has_many :partners, :dependent => :destroy

  def current_campaign
    campaigns.where("deadline > ? and ready_for_donations = ?", 1.day.from_now.at_midnight, true).order(:deadline).first
  end
end
