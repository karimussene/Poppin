class Match < ApplicationRecord
  belongs_to :user
  belongs_to :cuisine

  validates :user, :cuisine, presence: true
end
